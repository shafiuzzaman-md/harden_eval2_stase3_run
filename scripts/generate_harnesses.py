#!/usr/bin/env python3
"""Auto-generate userspace AddressSanitizer harnesses for each bug
the active CodeQL rule fires on, using the Claude Code CLI as the
synthesis backend.

For every (file, line) pair that:
  (a) appears in the published ground-truth manifest, AND
  (b) the static rule fires on,
this script asks Claude to write a complete C harness that:
  - `#include`s the source verbatim,
  - drives execution to the bug site,
  - exposes harness-input state under `#ifdef __KLEE__` for symex
    plus a hard-coded fallback for direct ASan runs,
  - compiles cleanly under `gcc -fsanitize=address`,
  - crashes ASan at the exact `(file, line)` the rule flagged.

After Claude returns, the script validates the generated harness by
building + running it under ASan and confirming the crash lands at the
expected line. Failed generations are retried up to MAX_TRIES with the
prior failure surfaced back to Claude as feedback.

Successful harnesses are written to
`dataset/corpus/harnesses/harness_<file_stem>_line<line>.c`.

CLI:
    scripts/generate_harnesses.py \\
        --rule rules/generated/X.ql \\
        --manifest dataset/EVAL3_LINUX_TARGETS.json \\
        --codeql-csv out/repro/repro.csv \\
        --dataset-root dataset/corpus \\
        --out dataset/corpus/harnesses \\
        [--force]      # ignore cached harnesses, regenerate every one
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ASAN_FRAME_RE = re.compile(
    r"#0\s+0x\S+\s+in\s+(?P<func>\w+)\s+\S*?(?P<file>[^/\s:]+\.c):(?P<line>\d+)"
)
# Matches ANY frame in the ASan stack, not just #0 — used so CFH-style
# crashes (where #0 is the bogus indirect-call target with no source
# info, and the call site is one frame up) still validate.
ASAN_ANY_FRAME_RE = re.compile(
    r"#\d+\s+0x\S+\s+in\s+(?P<func>\w+)\s+\S*?(?P<file>[^/\s:]+\.c):(?P<line>\d+)"
)
CODEQL_HIT_RE = re.compile(r'^"?file://(?P<file>.+\.c):(?P<line>\d+):')

CLAUDE_BIN = os.environ.get("CLAUDE_BIN", "claude")
MAX_TRIES = int(os.environ.get("HARNESS_GEN_RETRIES", "3"))
CLAUDE_TIMEOUT = int(os.environ.get("CLAUDE_TIMEOUT", "300"))


def codeql_hits(csv: Path) -> set[tuple[str, int]]:
    out: set[tuple[str, int]] = set()
    if not csv.is_file():
        return out
    for row in csv.read_text(errors="ignore").splitlines():
        m = CODEQL_HIT_RE.match(row)
        if m:
            out.add((Path(m.group("file")).name, int(m.group("line"))))
    return out


def find_source(dataset_root: Path, basename: str) -> Path | None:
    for r, _, fs in os.walk(dataset_root / "src"):
        if basename in fs:
            return Path(r) / basename
    return None


def harness_filename(bug_file: str, bug_line: int) -> str:
    return f"harness_{Path(bug_file).stem}_line{bug_line}.c"


def build_prompt(*, source_text: str, source_path: Path, bug_file: str,
                 bug_line: int, bug_function: str, dataset_root: Path,
                 prior_failure: str | None,
                 sanitizer: str = "asan",
                 bug_class: str | None = None,
                 reproducer_hint: str | None = None) -> str:
    """Compose the synthesis prompt for Claude."""
    src_lines = source_text.splitlines()
    bug_source_line = (
        src_lines[bug_line - 1] if 0 < bug_line <= len(src_lines) else ""
    )
    include_dirs = [
        dataset_root / "src" / "include",
        dataset_root / "src",
    ]
    feedback = ""
    if prior_failure:
        feedback = (
            "\n\nThe previous attempt FAILED validation. "
            "Diagnostic from that run:\n```\n" + prior_failure[:1500] + "\n```\n"
            "Please address this failure in your next answer."
        )
    san_name = {"asan": "AddressSanitizer",
                "ubsan": "UndefinedBehaviorSanitizer",
                "asan_ubsan": "AddressSanitizer+UndefinedBehaviorSanitizer"}.get(
                    sanitizer, "AddressSanitizer")
    san_flag = {"asan": "-fsanitize=address -fno-omit-frame-pointer",
                "ubsan": "-fsanitize=undefined -fno-sanitize-recover=all",
                "asan_ubsan": "-fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer"}.get(
                    sanitizer, "-fsanitize=address -fno-omit-frame-pointer")
    extra_class = (f"\nBug class hint: {bug_class}" if bug_class else "")
    extra_hint = (f"\nReproducer hint: {reproducer_hint}" if reproducer_hint else "")
    return f"""You are writing a userspace {san_name} harness for a memory-safety / undefined-behavior bug.

Bug location: {bug_file}:{bug_line}
Bug function: {bug_function}{extra_class}{extra_hint}
Source line at the bug:
    {bug_source_line.strip()}

Source file (verbatim, for context):
```c
{source_text}
```

Build context:
- Source file path (in the dataset, for reference): "../src/{source_path.relative_to(dataset_root / 'src')}"
- Include paths: {', '.join(str(p) for p in include_dirs)}
- The dataset's "linux/*.h" stubs are MINIMAL — they do NOT cover everything the original kernel source uses. DO NOT `#include` the verbatim driver source unless you can also provide stubs for every kernel type/macro it references.
- kmalloc/kzalloc/krealloc/kfree can be safely macro'd to malloc/calloc/realloc/free.

Requirements (every one MUST hold):
1. Produce a SELF-CONTAINED reproducer that compiles with userspace gcc without requiring real kernel headers. Strategy: copy/adapt JUST the buggy function (and any minimal helpers it calls) into the harness. Replace kernel-specific calls with userspace equivalents:
     copy_to_user / copy_from_user  →  memcpy
     get_user / put_user            →  *(dst) = *(src)
     kmalloc / kzalloc              →  malloc / calloc
     kfree                          →  free
     printk / pr_* / pr_debug       →  no-op #defines
     mutex_lock / spin_lock         →  no-op #defines
     EXPORT_SYMBOL / MODULE_*       →  no-op #defines
     struct file*, struct inode*    →  forward-declare or omit if unused
   Preserve the exact line numbers of the buggy line so the harness's `{bug_file}` lookalike crashes at line {bug_line} of the harness itself, OR name the harness's reproducer file the same and have the crash report it at any line — the validator accepts any frame mentioning a file named `{bug_file}:{bug_line}`. The simplest way: in your harness, place the adapted buggy function so its key line aligns to line {bug_line}; or include a `#line {bug_line} "{bug_file}"` directive immediately before the buggy line.
2. main() drives execution to the bug via the harness inputs (call the adapted function with attacker-shaped arguments).
3. Use `#ifdef __KLEE__` for symbolic exploration:
     - declare each attacker-controlled value with `klee_make_symbolic(&var, sizeof(var), "var_name");`
     - constrain the inputs with `klee_assume(...)` to keep KLEE on the bug-firing path
     - bounded constraints (e.g. `klee_assume(x < (size_t)(1ULL<<32))`) prevent KLEE drifting to unrelated paths
   Use `#else` for direct sanitizer runs:
     - hard-coded `<var> = 0xCONST;` lines that satisfy the same constraints and crash at the bug
     - constants in the form `<var> = 0xHEX;` (one per line) so KLEE-discovered concrete values can be substituted later
4. The harness MUST crash {san_name} (i.e. produce a `{san_name}` trip OR a `runtime error` line) with a stack frame mentioning `{bug_file}:{bug_line}` when compiled with:
     gcc -g -O0 {san_flag} -w -I "{include_dirs[0]}" -I "{include_dirs[1]}" harness.c -o harness
5. Provide all macro shims you need (kmalloc, mutex_lock, etc.) at the top of the harness as `#define`s.
{feedback}

Output ONLY the complete C source for the harness — no markdown fences, no commentary, no explanation. Just plain C code starting with the first `#include` or `/*` comment.
"""


def call_claude(prompt: str) -> str:
    """Invoke `claude -p "<prompt>"` and return stdout. Strips markdown
    code fences if Claude added them despite the instruction."""
    cp = subprocess.run(
        [CLAUDE_BIN, "-p", prompt],
        capture_output=True, timeout=CLAUDE_TIMEOUT,
    )
    if cp.returncode != 0:
        raise RuntimeError(
            f"claude exited {cp.returncode}: {cp.stderr.decode(errors='replace')[:500]}"
        )
    text = cp.stdout.decode(errors="replace")
    # Strip a leading ```c / ``` and trailing ```.
    text = re.sub(r"^\s*```(?:c|cpp)?\s*\n", "", text)
    text = re.sub(r"\n```\s*$", "", text)
    return text.strip() + "\n"


SANITIZER_FLAGS = {
    "asan":       ["-fsanitize=address", "-fno-omit-frame-pointer"],
    "ubsan":      ["-fsanitize=undefined", "-fno-sanitize-recover=all"],
    "asan_ubsan": ["-fsanitize=address,undefined", "-fno-sanitize-recover=undefined",
                   "-fno-omit-frame-pointer"],
}
SANITIZER_TRIP_PATTERNS = {
    "asan":       ("AddressSanitizer", ASAN_ANY_FRAME_RE),
    "ubsan":      ("runtime error", re.compile(r"(?P<file>[^/\s:]+\.c):(?P<line>\d+):\d+:\s+runtime error")),
    "asan_ubsan": ("AddressSanitizer|runtime error", re.compile(
        r"(?:#\d+\s+0x\S+\s+in\s+\w+\s+\S*?(?P<file>[^/\s:]+\.c):(?P<line>\d+))"
        r"|(?:(?P<file2>[^/\s:]+\.c):(?P<line2>\d+):\d+:\s+runtime error)"
    )),
}


def validate_harness(*, harness_text: str, dataset_root: Path,
                     bug_file: str, bug_line: int,
                     sanitizer: str = "asan") -> tuple[bool, str]:
    """Build the harness with gcc+sanitizer, run it, return (validated, log)."""
    flags = SANITIZER_FLAGS.get(sanitizer, SANITIZER_FLAGS["asan"])
    label, frame_re = SANITIZER_TRIP_PATTERNS.get(
        sanitizer, SANITIZER_TRIP_PATTERNS["asan"]
    )
    with tempfile.TemporaryDirectory() as tmp:
        tdir = Path(tmp)
        src = tdir / "harness.c"
        src.write_text(harness_text)
        bin_path = tdir / "harness"
        cmd = [
            "gcc", "-g", "-O0", *flags, "-w",
            "-I", str(dataset_root / "src" / "include"),
            "-I", str(dataset_root / "src"),
            str(src), "-o", str(bin_path),
        ]
        b = subprocess.run(cmd, capture_output=True, timeout=120)
        if b.returncode != 0:
            return False, f"BUILD FAILED:\n{b.stderr.decode(errors='replace')[:2000]}"
        r = subprocess.run([str(bin_path)], capture_output=True, timeout=30,
                           env={**os.environ, "UBSAN_OPTIONS": "print_stacktrace=1:halt_on_error=1"})
        log = (r.stdout + r.stderr).decode(errors="replace")
        for fm in frame_re.finditer(log):
            f = fm.groupdict().get("file") or fm.groupdict().get("file2")
            ln = fm.groupdict().get("line") or fm.groupdict().get("line2")
            if f == bug_file and ln and int(ln) == bug_line:
                return True, "OK"
        if not re.search(label, log):
            return False, f"NO {sanitizer} trip detected. Run output:\n{log[:1500]}"
        # Pick any frame to mention.
        m = frame_re.search(log)
        f = (m.groupdict().get("file") if m else None) or (m.groupdict().get("file2") if m else None) or "?"
        ln = (m.groupdict().get("line") if m else None) or (m.groupdict().get("line2") if m else None) or "?"
        return False, (
            f"{sanitizer} tripped at {f}:{ln} "
            f"(no frame matched expected {bug_file}:{bug_line}).\n{log[:1500]}"
        )


def generate_one(*, manifest_row: dict, source_text: str, source_path: Path,
                 dataset_root: Path, validate: bool = True) -> tuple[str, str] | None:
    """Try up to MAX_TRIES times to get a validating harness. Returns
    (text, last_log) on success, None on exhaustion. If validate=False,
    return the first harness that compiles."""
    bug_file = Path(manifest_row["file"]).name
    bug_line = int(manifest_row["line"])
    sanitizer = manifest_row.get("sanitizer", "asan")
    prior = None
    last_log = ""
    for attempt in range(1, MAX_TRIES + 1):
        prompt = build_prompt(
            source_text=source_text, source_path=source_path,
            bug_file=bug_file, bug_line=bug_line,
            bug_function=manifest_row.get("function") or "?",
            dataset_root=dataset_root, prior_failure=prior,
            sanitizer=sanitizer,
            bug_class=manifest_row.get("bug_class"),
            reproducer_hint=manifest_row.get("reproducer_hint"),
        )
        try:
            harness_text = call_claude(prompt)
        except Exception as e:
            last_log = f"claude call failed: {e}"
            prior = last_log
            continue
        if not validate:
            # Best-effort: just check it compiles. KLEE downstream is the oracle.
            with tempfile.TemporaryDirectory() as tmp:
                tdir = Path(tmp)
                src = tdir / "harness.c"
                src.write_text(harness_text)
                cmd = ["gcc", "-g", "-O0", "-w", "-c",
                       "-I", str(dataset_root / "src" / "include"),
                       "-I", str(dataset_root / "src"),
                       str(src), "-o", str(tdir / "harness.o")]
                b = subprocess.run(cmd, capture_output=True, timeout=60)
                if b.returncode == 0:
                    return harness_text, "compiled-only (no validation)"
                prior = f"BUILD FAILED:\n{b.stderr.decode(errors='replace')[:2000]}"
                last_log = prior
                continue
        ok, log = validate_harness(
            harness_text=harness_text, dataset_root=dataset_root,
            bug_file=bug_file, bug_line=bug_line,
            sanitizer=sanitizer,
        )
        if ok:
            return harness_text, log
        prior = log
        last_log = log
    return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n", 1)[0])
    ap.add_argument("--rule",         type=Path, required=True)
    ap.add_argument("--codeql-csv",   type=Path, required=True)
    ap.add_argument("--dataset-root", type=Path, required=True)
    ap.add_argument("--manifest",     type=Path, default=None,
                    help="optional ground-truth manifest JSON. If supplied, "
                         "only sites in the manifest are attempted; otherwise "
                         "every CodeQL hit in driver source files is tried.")
    ap.add_argument("--manifest-only", action="store_true",
                    help="when --manifest is given, use it as the only target "
                         "source — do NOT intersect with codeql hits.")
    ap.add_argument("--no-validate", action="store_true",
                    help="skip sanitizer-trip validation; accept any harness "
                         "Claude produces that compiles. Useful for bug shapes "
                         "no sanitizer can confirm in userspace.")
    ap.add_argument("--out",          type=Path, required=True,
                    help="harness output dir (e.g. dataset/corpus/harnesses/)")
    ap.add_argument("--force", action="store_true",
                    help="regenerate even if a cached harness already exists")
    ap.add_argument("--max-targets", type=int, default=20,
                    help="safety cap on Claude calls per run (default 20)")
    args = ap.parse_args()

    if not shutil.which(CLAUDE_BIN):
        print(f"  ✗ {CLAUDE_BIN} not on PATH; cannot auto-generate harnesses",
              file=sys.stderr)
        return 2

    args.out.mkdir(parents=True, exist_ok=True)

    # Load CodeQL hits with full path so we can filter to driver sources.
    hit_lines = (args.codeql_csv.read_text(errors="ignore").splitlines()
                 if args.codeql_csv.is_file() else [])
    hit_by_basename: set[tuple[str, int]] = set()
    full_hits: list[tuple[str, str, int]] = []   # (full_path, basename, line)
    for line in hit_lines:
        m = CODEQL_HIT_RE.match(line)
        if not m:
            continue
        full = m.group("file")
        bn   = Path(full).name
        ln   = int(m.group("line"))
        hit_by_basename.add((bn, ln))
        full_hits.append((full, bn, ln))

    targets: list[dict] = []
    seen: set[tuple[str, int]] = set()
    if args.manifest is not None and args.manifest.is_file():
        for row in json.loads(args.manifest.read_text()):
            bn = Path(row["file"]).name
            ln = int(row["line"])
            if args.manifest_only:
                if (bn, ln) not in seen:
                    targets.append({**row, "file": bn, "line": ln})
                    seen.add((bn, ln))
            elif (bn, ln) in hit_by_basename and (bn, ln) not in seen:
                targets.append({**row, "file": bn, "line": ln})
                seen.add((bn, ln))
    else:
        for full, bn, ln in full_hits:
            # Skip header-file hits — those are nearly always macro
            # false positives, not real bugs.
            if "/include/" in full or full.endswith(".h"):
                continue
            if (bn, ln) not in seen:
                targets.append({"file": bn, "line": ln})
                seen.add((bn, ln))

    # Triage which targets need fresh generation vs. are already cached.
    to_generate: list[dict] = []
    n_total = len(targets)
    n_kept = 0
    for row in targets:
        target_path = args.out / harness_filename(row["file"], row["line"])
        if target_path.is_file() and not args.force:
            print(f"  ✓ cached harness present: {target_path.name}")
            n_kept += 1
            continue
        to_generate.append(row)
    if (cap := args.max_targets) and len(to_generate) > cap:
        print(f"  ⚠ {len(to_generate)} sites need generation; capping at "
              f"--max-targets={cap}")
        to_generate = to_generate[:cap]

    # Parallel Claude calls. Claude is I/O-bound (RPC + remote inference),
    # so threads are sufficient; CONCURRENCY caps the simultaneous calls.
    import concurrent.futures
    concurrency = int(os.environ.get("HARNESS_GEN_CONCURRENCY",
                                     str(min(8, max(1, len(to_generate))))))

    def _do(row: dict) -> tuple[dict, str | None]:
        src = find_source(args.dataset_root, row["file"])
        if src is None:
            return row, None
        source_text = src.read_text()
        result = generate_one(
            manifest_row=row, source_text=source_text, source_path=src,
            dataset_root=args.dataset_root,
            validate=not args.no_validate,
        )
        if result is None:
            return row, None
        harness_text, _ = result
        target_path = args.out / harness_filename(row["file"], row["line"])
        target_path.write_text(harness_text)
        return row, harness_text

    n_generated = 0
    n_failed = 0
    if to_generate:
        print(f"  → generating {len(to_generate)} harness(es) in parallel "
              f"(concurrency={concurrency})...")
    with concurrent.futures.ThreadPoolExecutor(max_workers=concurrency) as ex:
        futures = {ex.submit(_do, r): r for r in to_generate}
        for fut in concurrent.futures.as_completed(futures):
            row = futures[fut]
            try:
                _, harness = fut.result()
            except Exception as e:
                print(f"  ✗ {row['file']}:{row['line']} threw: {e}",
                      file=sys.stderr)
                n_failed += 1
                continue
            if harness is None:
                print(f"  ✗ Claude failed to produce a validating harness for "
                      f"{row['file']}:{row['line']} after {MAX_TRIES} attempts",
                      file=sys.stderr)
                n_failed += 1
            else:
                print(f"  ✓ wrote "
                      f"{harness_filename(row['file'], row['line'])}")
                n_generated += 1

    # The original sequential path below is kept as dead code in case the
    # threadpool ever misbehaves; replaced by the block above.
    for row in []:
        bug_file = row["file"]
        bug_line = row["line"]
        target_path = args.out / harness_filename(bug_file, bug_line)
        if target_path.is_file() and not args.force:
            n_kept += 1
            continue
        if (n_generated + n_failed) >= args.max_targets:
            print(f"  ⚠ hit --max-targets={args.max_targets}; remaining sites skipped")
            break
        src = find_source(args.dataset_root, bug_file)
        if src is None:
            print(f"  ✗ source not found for {bug_file}", file=sys.stderr)
            n_failed += 1
            continue
        source_text = src.read_text()
        print(f"  → generating harness for {bug_file}:{bug_line} via Claude...")
        result = generate_one(
            manifest_row=row, source_text=source_text, source_path=src,
            dataset_root=args.dataset_root,
            validate=not args.no_validate,
        )
        if result is None:
            print(f"  ✗ Claude failed to produce a validating harness for "
                  f"{bug_file}:{bug_line} after {MAX_TRIES} attempts",
                  file=sys.stderr)
            n_failed += 1
            continue
        harness_text, _ = result
        target_path.write_text(harness_text)
        print(f"  ✓ wrote {target_path.name}")
        n_generated += 1

    print()
    print(f"  summary: targets={n_total}  cached={n_kept}  generated={n_generated}  failed={n_failed}")
    # Non-fatal even when some targets fail — the downstream consolidator
    # only emits findings for harnesses that ASan validates anyway.
    return 0


if __name__ == "__main__":
    sys.exit(main())
