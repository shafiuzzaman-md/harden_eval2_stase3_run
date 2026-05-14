#!/usr/bin/env python3
"""Consolidate Path-A artifacts + CodeQL hits + ground-truth manifest into
per-confirmed-finding directories.

For every harness that landed an ASan crash, this script:

  1. Parses the ASan log for the file:line:function of the actual crash.
  2. Cross-references that location against the CodeQL hit CSV (so we only
     ship findings where the static rule also fired) and against the
     ground-truth manifest (so we know which planted bug it confirms).
  3. Harvests every KLEE *.kquery file as an SMT path-condition and tags
     bug-witness paths (those with a sibling *.ptr.err).
  4. Emits a single self-contained, spec-aligned `wmi.json` plus the
     harness source (`reproducer.c`) and the verbatim ASan log
     (`reproducer.log`) under <out>/<finding-uuid>/.

The script is fully automatic: there is no hard-coded list of targets.
Add a harness under dataset/corpus/harnesses/, run scripts/run_path_a.sh,
re-run this script, and any new confirmed bug is consolidated alongside.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import sys
import uuid
from pathlib import Path

ASAN_FRAME_RE = re.compile(
    r"#0\s+0x\S+\s+in\s+(?P<func>\w+)\s+\S*?(?P<file>[^/\s:]+\.c):(?P<line>\d+)"
)
# Matches ANY frame in the ASan stack (not just #0). Used by the
# replay-validation gate so that CFH-style crashes — where the
# indirect call to a corrupted function pointer puts an unresolved
# bogus address at #0 and the call site appears one or two frames
# higher — still validate when the call site shows up anywhere in
# the stack.
ASAN_ANY_FRAME_RE = re.compile(
    r"#\d+\s+0x\S+\s+in\s+(?P<func>\w+)\s+\S*?(?P<file>[^/\s:]+\.c):(?P<line>\d+)"
)
ASAN_VIOLATION_RE = re.compile(r"AddressSanitizer:\s*(\S+)")
ASAN_EXCERPT_RE = re.compile(
    r"==\d+==ERROR: AddressSanitizer.*?(?:SUMMARY:.*?\n|\Z)", re.DOTALL
)
CODEQL_HIT_RE = re.compile(r'^"?file://(?P<file>.+\.c):(?P<line>\d+):')


def _first_user_frame(text: str) -> "re.Match | None":
    """Pick the first stack frame whose file is a .c file outside the
    sanitizer/libc runtime — so a SEGV/OOB whose #0 is memcpy /
    __memmove_avx in libc still attributes to the harness call site."""
    for fm in ASAN_ANY_FRAME_RE.finditer(text):
        f = fm.group("file")
        if not f.endswith(".c"):
            continue
        # Skip libsanitizer and glibc internals.
        full = text[max(0, fm.start() - 0):fm.end()]
        if "libsanitizer" in full or "sysdeps/" in full or "glibc" in full:
            continue
        return fm
    return None


def parse_asan_log(path: Path) -> dict | None:
    """Return {file, line, function, violation_type, excerpt} or None.

    Prefers the #0 frame when it's a user-source .c file. If #0 is in
    libc/libsanitizer (e.g. a memcpy/__memmove_avx OOB), falls back to
    the first user-source .c frame so the crash attributes to the
    caller in the harness/driver rather than the runtime."""
    if not path.is_file():
        return None
    text = path.read_text(errors="ignore")
    frame = ASAN_FRAME_RE.search(text)
    if not frame:
        frame = _first_user_frame(text)
        if not frame:
            return None
    # UBSan `runtime error` lines emit "<file>:<line>:<col>: runtime error".
    # Prefer that file:line if present (matches the bug-line semantics).
    ubsan_m = re.search(
        r"(?P<file>[A-Za-z0-9_./-]+\.c):(?P<line>\d+):\d+:\s+runtime error",
        text,
    )
    if ubsan_m:
        file_basename = Path(ubsan_m.group("file")).name
        line_num = int(ubsan_m.group("line"))
        # find the function name from the next stack frame mentioning this file:line
        func_m = re.search(
            rf"#\d+\s+0x\S+\s+in\s+(\w+)\s+\S*?{re.escape(file_basename)}:{line_num}",
            text,
        )
        function = func_m.group(1) if func_m else (frame.group("func") if frame else "?")
    else:
        file_basename = Path(frame.group("file")).name
        line_num = int(frame.group("line"))
        function = frame.group("func")
    vio = ASAN_VIOLATION_RE.search(text)
    if not vio and ubsan_m:
        vio_label = "ubsan-runtime-error"
    else:
        vio_label = vio.group(1) if vio else "?"
    excerpt = ASAN_EXCERPT_RE.search(text)
    return {
        "file":           file_basename,
        "line":           line_num,
        "function":       function,
        "violation_type": vio_label,
        "excerpt":        (excerpt.group(0)[:2000] if excerpt else text[:2000]),
        "full":           text,
    }


def harvest_klee_preconditions(klee_dir: Path) -> tuple[list[str], list[dict]]:
    """Return (smt_strings, meta) where smt_strings is bug-witness-first.

    Prefers KLEE's `.smt2` (SMT-LIBv2) output when present, since that's
    what downstream chainers / validators actually parse; falls back to
    KLEE's native `.kquery` text. The body is taken verbatim from KLEE's
    file with the only modification being the removal of KLEE's leading
    `;`-comment lines (SMT-LIBv2 line comments — auto-emitted by KLEE,
    not part of the constraints) so preconditions are pure SMT-LIBv2.
    Each meta entry: {name, is_bug_witness, format, size_chars}."""
    if not klee_dir.is_dir():
        return [], []
    smt2s = list(klee_dir.glob("*.smt2"))
    fmt = "smt2" if smt2s else "kquery"
    files = smt2s if smt2s else list(klee_dir.glob("*.kquery"))
    files.sort(
        key=lambda p: (
            not (klee_dir / f"{p.stem}.ptr.err").exists(),
            p.name,
        ),
    )
    smt_strings: list[str] = []
    meta: list[dict] = []
    for f in files:
        body = f.read_text(errors="ignore")
        if fmt == "smt2":
            body = "\n".join(
                ln for ln in body.splitlines() if not ln.lstrip().startswith(";")
            ).strip() + "\n"
        is_witness = (klee_dir / f"{f.stem}.ptr.err").exists()
        smt_strings.append(body)
        meta.append({
            "name":           f.stem,
            "is_bug_witness": is_witness,
            "format":         fmt,
            "size_chars":     len(body),
        })
    return smt_strings, meta


def parse_ktest(path: Path) -> list[dict]:
    """Parse KLEE's `.ktest` binary format → list of symbolic-object records.

    Each record: {name, size_bytes, value_le_hex, value_bytes_be_hex,
    value_uint_le}. KLEE stores raw bytes; on x86 (little-endian) the
    integer interpretation is the LE-decoded value, which is what a C
    program reading the same memory would see.
    Returns [] if the file is malformed or absent."""
    if not path.is_file():
        return []
    try:
        data = path.read_bytes()
    except OSError:
        return []
    if not data.startswith(b"KTEST"):
        return []
    pos = 5
    if pos + 4 > len(data):
        return []
    version = int.from_bytes(data[pos:pos + 4], "big"); pos += 4
    num_args = int.from_bytes(data[pos:pos + 4], "big"); pos += 4
    for _ in range(num_args):
        if pos + 4 > len(data):
            return []
        arg_len = int.from_bytes(data[pos:pos + 4], "big"); pos += 4
        pos += arg_len
    if version >= 2:
        pos += 8           # sym_argvs + sym_argv_len
    if pos + 4 > len(data):
        return []
    num_objects = int.from_bytes(data[pos:pos + 4], "big"); pos += 4
    objs: list[dict] = []
    for _ in range(num_objects):
        if pos + 4 > len(data):
            break
        name_len = int.from_bytes(data[pos:pos + 4], "big"); pos += 4
        name = data[pos:pos + name_len].decode("utf-8", errors="replace")
        pos += name_len
        if pos + 4 > len(data):
            break
        size = int.from_bytes(data[pos:pos + 4], "big"); pos += 4
        body = data[pos:pos + size]; pos += size
        le_int = int.from_bytes(body, "little")
        objs.append({
            "name":               name,
            "size_bytes":         size,
            "value_le_hex":       "0x" + format(le_int, "x"),
            "value_bytes_be_hex": "0x" + body.hex(),
            "value_uint_le":      le_int,
        })
    return objs


def derive_verdict_kind(witness_validation: dict, smt_strings: list[str]) -> str:
    """Map (symex evidence, concrete-replay outcome) → verdict label.
    No hardcoded "concrete_confirmed" — the label reflects what the
    pipeline actually observed."""
    if witness_validation.get("validated"):
        return "concrete_confirmed"   # static + symex + concrete-replay all agree
    if smt_strings:
        return "symex_explored"       # static fired AND symex reached the bug path
    return "static_candidate"          # only the static rule fired


def parse_rule_metadata(rule_path: Path) -> dict:
    """Read the CodeQL `.ql` file's leading docblock and extract metadata
    annotations: @id, @name, @kind, @tags. Returns a dict with keys
    `id`, `name`, `cwe` (e.g. "CWE-787"), `sanitizer`, `oracle`,
    `kind`, `effect`, `width`. All values are strings.

    `effect` is read from a `effect/<type>` tag (e.g. `effect/write`)
    so the spec's effect-type vocabulary is declared by the rule itself
    rather than inferred from the CWE — there's no hardcoded
    CWE-to-effect mapping in this script.

    `width` is read from a `width/<bytes>` tag (e.g. `width/8`) and
    drives the size of memory-layout segment locations.
    """
    out = {"id": "", "name": "", "cwe": "", "sanitizer": "", "oracle": "",
           "kind": "", "effect": "", "width": ""}
    if not rule_path.is_file():
        return out
    text = rule_path.read_text(errors="ignore")
    m = re.search(r"/\*\*(.*?)\*/", text, re.DOTALL)
    if not m:
        return out
    block = m.group(1)
    for tag in ("id", "name", "kind"):
        mt = re.search(rf"@{tag}\s+(.+)", block)
        if mt:
            out[tag] = mt.group(1).strip()
    tags = re.search(r"@tags\s+(.*?)(?=\n\s*\*\s*@|\n\s*\*\/|$)", block, re.DOTALL)
    if tags:
        toks = re.findall(r"\S+", tags.group(1))
        for t in toks:
            tl = t.lower()
            if "cwe-" in tl or "cwe_" in tl:
                cwe_m = re.search(r"cwe[-_](\d+)", tl)
                if cwe_m:
                    out["cwe"] = "CWE-" + cwe_m.group(1)
            elif tl.startswith("sanitizer/"):
                out["sanitizer"] = tl.split("/", 1)[1]
            elif tl.startswith("oracle/"):
                out["oracle"] = tl.split("/", 1)[1]
            elif tl.startswith("effect/"):
                # Preserve original case so e.g. effect/executeAddr stays camelCase.
                out["effect"] = t.split("/", 1)[1]
            elif tl.startswith("width/"):
                out["width"] = tl.split("/", 1)[1]
    return out


def derive_parameters_meta(
    harness_text: str,
    dataset_root: Path,
    witness_args: list[dict],
) -> list[dict]:
    """For each KLEE-witness symbolic input, derive a deterministic
    source-code anchor by parsing the harness:
      - if the symbol is passed as an argument to a function call,
        look up that function's signature in dataset_root/src/ and
        report which parameter slot it fills (role: function_argument);
      - if the symbol is assigned into memory (e.g. ((block_t*)heap)->...
        = sym), capture the LHS expression (role: attacker_state);
      - else role: unknown.

    Returns one entry per witness arg, parallel to operation.parameters.
    Computed entirely from static text; no LLM dependency."""
    SKIP_CALLEES = {
        "klee_make_symbolic", "klee_assume", "klee_assume_eq",
        "sizeof", "offsetof", "container_of",
        "if", "while", "for", "switch", "return",
    }
    # Strip C/C++ comments so the assignment / call regexes don't match
    # comment text.
    code = re.sub(r"/\*.*?\*/", " ", harness_text, flags=re.DOTALL)
    code = re.sub(r"//[^\n]*", " ", code)
    harness_text = code
    out: list[dict] = []
    for w in witness_args:
        sym = w["name"]
        call = None
        for m in re.finditer(
            rf"\b([A-Za-z_]\w*)\s*\(([^()]*\b{re.escape(sym)}\b[^()]*)\)",
            harness_text,
        ):
            if m.group(1) not in SKIP_CALLEES:
                call = m
                break
        if call:
            func_name = call.group(1)
            args_text = call.group(2)
            # Index of `sym` among the comma-separated args (depth 0).
            depth = 0
            arg_idx = 0
            buf = ""
            args_in_order: list[str] = []
            for ch in args_text + ",":
                if ch == "(":
                    depth += 1; buf += ch
                elif ch == ")":
                    depth -= 1; buf += ch
                elif ch == "," and depth == 0:
                    args_in_order.append(buf.strip()); buf = ""
                else:
                    buf += ch
            sym_idx: int | None = None
            for i, a in enumerate(args_in_order):
                if re.search(rf"\b{re.escape(sym)}\b", a):
                    sym_idx = i; break
            sig = _find_function_signature(dataset_root, func_name)
            if sig and sym_idx is not None and sym_idx < len(sig):
                ptype, pname = sig[sym_idx]
                out.append({
                    "role":               "function_argument",
                    "source_function":    func_name,
                    "source_param_index": sym_idx,
                    "source_param_name":  pname,
                    "source_param_type":  ptype,
                })
                continue
            out.append({
                "role":            "function_argument",
                "source_function": func_name,
            })
            continue
        # Look for assignment: `<lhs> = ... sym ... ;`
        assign = re.search(
            rf"([^=;\n]+?)\s*=\s*[^=;]*\b{re.escape(sym)}\b\s*;",
            harness_text,
        )
        if assign:
            out.append({
                "role":      "attacker_state",
                "writes_to": assign.group(1).strip(),
            })
            continue
        out.append({"role": "unknown"})
    return out


def _find_function_signature(
    dataset_root: Path,
    func_name: str,
) -> list[tuple[str, str]] | None:
    """Walk dataset_root/src/ looking for a definition `<ret> <func>(<args>)`
    and parse the comma-separated parameter list into (type, name) tuples.
    Returns None if not found / unparseable."""
    pat = re.compile(
        rf"\b\w[\w\s\*]*\b{re.escape(func_name)}\s*\(([^)]*)\)\s*\{{",
        re.MULTILINE,
    )
    for r, _, fs in os.walk(dataset_root / "src"):
        for f in fs:
            if not f.endswith(".c"):
                continue
            try:
                text = (Path(r) / f).read_text(errors="ignore")
            except OSError:
                continue
            m = pat.search(text)
            if not m:
                continue
            params: list[tuple[str, str]] = []
            for raw in m.group(1).split(","):
                raw = raw.strip()
                if not raw or raw == "void":
                    continue
                # Split last identifier off as the name; rest is the type.
                t = re.match(r"(.+?)\s*\b([A-Za-z_]\w*)\s*$", raw)
                if t:
                    ptype = re.sub(r"\s+", " ", t.group(1)).strip()
                    params.append((ptype, t.group(2)))
                else:
                    params.append((raw, ""))
            return params
    return None


def read_source_line(dataset_root: Path, file: str, line: int) -> str:
    """Read the actual source line at (file, line) so the WMI carries
    the bug-firing statement verbatim. Returns "" if not readable."""
    for root, _, files in os.walk(dataset_root / "src"):
        if file in files:
            try:
                lines = (Path(root) / file).read_text(errors="ignore").splitlines()
            except OSError:
                return ""
            if 0 < line <= len(lines):
                return lines[line - 1].strip()
    return ""


def _find_source_file(dataset_root: Path, file: str) -> Path | None:
    for root, _, files in os.walk(dataset_root / "src"):
        if file in files:
            return Path(root) / file
    return None


def derive_enclosing_function(dataset_root: Path, file: str, line: int) -> str:
    """Find the function that contains (file, line) by parsing the source.

    Walks forward tracking brace depth. Remembers the most-recent
    function-definition header seen at file scope; when depth transitions
    0→1, commits that header as the enclosing function for the body
    that follows. Returns "?" if not derivable."""
    src_file = _find_source_file(dataset_root, file)
    if src_file is None:
        return "?"
    try:
        text_lines = src_file.read_text(errors="ignore").splitlines()
    except OSError:
        return "?"
    # Kernel-style header pattern: <type> <name>(<params>) — ends with `)`,
    # no trailing `;` or `=`, and the line itself doesn't start with `#`,
    # `*`, or `/` (excludes preprocessor + comment lines that contain `(`).
    HDR_RE = re.compile(r"\b([A-Za-z_]\w*)\s*\([^;]*\)\s*$")
    enclosing = "?"
    pending_header: str | None = None
    depth = 0
    for i, ln in enumerate(text_lines, start=1):
        if depth == 0:
            stripped = ln.lstrip()
            if stripped and stripped[0] not in "#*/":
                m = HDR_RE.search(ln)
                if m:
                    pending_header = m.group(1)
        # Crude brace counting — doesn't strip strings/comments. Fine for
        # the corpus we ship, which doesn't have brace-in-string oddities.
        open_b = ln.count("{")
        close_b = ln.count("}")
        prev_depth = depth
        depth += open_b - close_b
        # 0 → >0: just entered a function body. Commit the pending header.
        if prev_depth == 0 and depth > 0 and pending_header:
            enclosing = pending_header
            pending_header = None
        # >0 → 0: just exited a function body. Clear.
        if prev_depth > 0 and depth == 0:
            enclosing = "?"
        if i == line:
            return enclosing
    return "?"


def derive_destination(dataset_root: Path, file: str, line: int,
                       effect_type: str = "write") -> tuple[str, str]:
    """Read the source file at (file, line) and extract the destination of
    the operation as the segment name. Returns (segment_name, raw_expr).

    For write-shaped effects, extracts the assignment LHS:
        `block->header = size | alloc;`            → ("block_header", "block->header")
        `heap.free_list[chunk_size] = ...;`        → ("heap_free_list_chunk_size", "heap.free_list[chunk_size]")

    For executeAddr (indirect call), extracts the callee expression:
        `pot->mood_action(pot);`                   → ("pot_mood_action", "pot->mood_action")

    Falls back to ("write_destination", "?") if the source can't be read
    or the pattern doesn't match."""
    src_file = _find_source_file(dataset_root, file)
    if src_file is None or not src_file.is_file():
        return "write_destination", "?"
    try:
        text_lines = src_file.read_text(errors="ignore").splitlines()
    except OSError:
        return "write_destination", "?"
    if not (0 < line <= len(text_lines)):
        return "write_destination", "?"
    code = text_lines[line - 1].strip()

    if effect_type == "executeAddr":
        # Indirect call: `<callee-expr>(<args>);`. Pull out the callee.
        m = re.match(r"([A-Za-z_][\w\->\.\[\]]*)\s*\(", code)
        if m:
            callee = m.group(1)
            seg = re.sub(r"\W+", "_", callee).strip("_") or "execute_target"
            return seg, callee
        return "execute_target", "?"

    # Default (write-shaped): match `<lhs> = <rhs>` (skip == / != / etc.).
    m = re.match(r"([^=;{}]+?)\s*=\s*[^=]", code)
    if not m:
        return "write_destination", "?"
    lhs_raw = m.group(1).strip()
    seg = re.sub(r"\W+", "_", lhs_raw).strip("_") or "write_destination"
    return seg, lhs_raw


def harvest_witness_args(klee_dir: Path) -> tuple[list[dict], str | None]:
    """Pick the first bug-witness `.ktest` (i.e. one whose stem also has a
    `.ptr.err` sibling) and parse its symbolic objects.
    Returns (witness_args, witness_name) or ([], None)."""
    if not klee_dir.is_dir():
        return [], None
    candidates = sorted(klee_dir.glob("*.ktest"))
    for kt in candidates:
        if (klee_dir / f"{kt.stem}.ptr.err").exists():
            objs = parse_ktest(kt)
            if not objs:
                continue
            args = [
                {
                    "name":           o["name"],
                    "type":           f"int{o['size_bytes'] * 8}",
                    "value_le_hex":   o["value_le_hex"],
                    "value_uint_le":  o["value_uint_le"],
                    "size_bytes":     o["size_bytes"],
                    "source":         f"klee_witness:{kt.stem}",
                }
                for o in objs
            ]
            return args, kt.stem
    return [], None


_HARDCODE_RE_TEMPLATE = (
    r"(\b{name}\b\s*=\s*)0x[0-9a-fA-F]+(?:ULL|UL|U|LL|L)?"
)


def render_replay_harness(harness_text: str, witness: list[dict]) -> str:
    """Substitute each witness's value into the harness's hard-coded
    fallback assignment (`<name> = 0xCONST;`). The original harness is
    designed so the same source builds with `-D__KLEE__` for symex AND
    without for ASan; the without-`__KLEE__` branch reads concrete values
    from these `<name> = 0xCONST` assignments. We replace those with the
    KLEE-discovered witness so the resulting reproducer is a faithful
    concrete realization of the symex result."""
    out = harness_text
    for w in witness:
        pat = _HARDCODE_RE_TEMPLATE.format(name=re.escape(w["name"]))
        repl = rf"\g<1>{w['value_le_hex']}ULL"
        out = re.sub(pat, repl, out, count=1)
    return out


def validate_replay(
    *,
    harness_text: str,
    expected_file: str,
    expected_line: int,
    dataset_root: Path,
    work_dir: Path,
) -> dict:
    """Compile the witness-substituted harness under AddressSanitizer, run
    it, and confirm ASan trips at <expected_file>:<expected_line>.
    Returns a structured result; sets `validated: True` only on a
    matching ASan crash."""
    import subprocess
    src_path = work_dir / "replay.c"
    src_path.write_text(harness_text)
    bin_path = work_dir / "replay"
    cmd = [
        "gcc", "-g", "-O0", "-fsanitize=address",
        "-fno-omit-frame-pointer", "-w",
        "-I", str(dataset_root / "src" / "include"),
        "-I", str(dataset_root / "src"),
        str(src_path), "-o", str(bin_path),
    ]
    try:
        b = subprocess.run(cmd, capture_output=True, timeout=60)
    except subprocess.TimeoutExpired:
        return {"validated": False, "stage": "build", "error": "build timeout"}
    if b.returncode != 0:
        return {"validated": False, "stage": "build",
                "error": b.stderr.decode(errors="replace")[:500]}
    try:
        r = subprocess.run([str(bin_path)], capture_output=True, timeout=30)
    except subprocess.TimeoutExpired:
        return {"validated": False, "stage": "run", "error": "run timeout"}
    log = (r.stdout + r.stderr).decode(errors="replace")
    # Scan EVERY frame in the ASan stack (not just #0). For a WWW the
    # bug-firing instruction is at #0 (matches expected_file:line).
    # For a CFH the corrupted indirect call lands at an unresolved bogus
    # address at #0 and the actual call site is one or two frames up;
    # we accept the trip when ANY frame matches (file, line).
    matched_frame = None
    for fm in ASAN_ANY_FRAME_RE.finditer(log):
        if fm.group("file") == expected_file and int(fm.group("line")) == expected_line:
            matched_frame = fm
            break
    top_frame = ASAN_FRAME_RE.search(log)
    if not top_frame and not matched_frame:
        return {"validated": False, "stage": "run", "exit_code": r.returncode,
                "log_excerpt": log[:500]}
    got_file = (matched_frame or top_frame).group("file")
    got_line = int((matched_frame or top_frame).group("line"))
    return {
        "validated":         matched_frame is not None,
        "stage":             "run",
        "exit_code":         r.returncode,
        "asan_violation_at": f"{got_file}:{got_line}",
        "expected_at":       f"{expected_file}:{expected_line}",
        "match_frame":       "any" if matched_frame else None,
    }


def load_codeql_hits(csv_path: Path) -> set[tuple[str, int]]:
    if not csv_path.is_file():
        return set()
    hits: set[tuple[str, int]] = set()
    for row in csv_path.read_text(errors="ignore").splitlines():
        m = CODEQL_HIT_RE.match(row)
        if m:
            hits.add((Path(m.group("file")).name, int(m.group("line"))))
    return hits


def load_per_rule_hits(per_rule_csv_dir: Path) -> dict[str, set[tuple[str, int]]]:
    """Walk per_rule_csv_dir/<rule_stem>.csv and return {rule_stem: {(file,line),...}}."""
    out: dict[str, set[tuple[str, int]]] = {}
    if not per_rule_csv_dir.is_dir():
        return out
    for csv in sorted(per_rule_csv_dir.glob("*.csv")):
        out[csv.stem] = load_codeql_hits(csv)
    return out


def load_rule_meta_dir(rules_dir: Path) -> dict[str, dict]:
    """Return {rule_stem: parse_rule_metadata(<rules_dir>/<rule_stem>.ql)}.
    Only includes rules whose @tags carry effect/<...>, sanitizer/<...>,
    width/<n> — i.e. those eligible for the consolidator's WMI shape."""
    out: dict[str, dict] = {}
    if not rules_dir.is_dir():
        return out
    for q in sorted(rules_dir.glob("*.ql")):
        meta = parse_rule_metadata(q)
        if meta.get("effect") and meta.get("sanitizer") and meta.get("width"):
            out[q.stem] = meta
    return out


def select_rule_meta_for(
    *,
    asan_key: tuple[str, int],
    fallback_meta: dict,
    per_rule_hits: dict[str, set[tuple[str, int]]],
    rule_meta_by_stem: dict[str, dict],
) -> dict | None:
    """For a given crash (file, line), pick the rule whose static CSV
    contains that location. If none of the per-rule CSVs are available
    (single-rule mode), return the fallback metadata (the rule passed
    via --rule). If per-rule hits ARE available but none match the
    asan key, return None — no rule claims this crash so the finding
    is unattributable."""
    if not per_rule_hits:
        return fallback_meta or None
    for stem, hits in per_rule_hits.items():
        if asan_key in hits:
            meta = rule_meta_by_stem.get(stem)
            if meta:
                return meta
    return None


def load_manifest(path: Path) -> dict[tuple[str, int], dict]:
    """Return (file, line) -> ground-truth row."""
    if not path.is_file():
        return {}
    rows = json.loads(path.read_text())
    return {(Path(r["file"]).name, int(r["line"])): r for r in rows}


def harness_source_for(harnesses_dir: Path, pa_subdir_name: str) -> Path | None:
    """Convention: path_a subdir <stem> ↔ harnesses/harness_<stem>.c"""
    cand = harnesses_dir / f"harness_{pa_subdir_name}.c"
    return cand if cand.is_file() else None


def build_finding(
    *,
    pa_subdir: Path,
    asan: dict,
    codeql_hits: set[tuple[str, int]],
    manifest: dict[tuple[str, int], dict],
    harnesses_dir: Path,
    dataset_root: Path,
    rule_meta: dict | None,
    out_dir: Path,
) -> Path | None:
    """Build a single consolidated finding dir; return the dir or None.

    `rule_meta` is the metadata of the specific rule that fired for this
    crash (chosen by the caller based on per-rule CSV hits). If None,
    no eligible rule claims this site and the finding is skipped — that's
    consistent with the existing "no rule fired here" branch below."""
    key = (asan["file"], asan["line"])
    if key not in codeql_hits:
        # Static rule didn't fire here — don't claim a finding.
        return None
    if rule_meta is None:
        # No eligible rule (effect/sanitizer/width-tagged) claims this
        # crash; treat the same as "static rule didn't fire here".
        return None
    # Manifest is optional. When supplied, the row's labels override the
    # rule's @name as the human bug_type; when absent we fall back to the
    # rule metadata alone (no claim of correspondence to any external
    # ground truth).
    gt = manifest.get(key, {})

    smt_strings, smt_meta = harvest_klee_preconditions(pa_subdir / "klee")
    witness_args, witness_name = harvest_witness_args(pa_subdir / "klee")

    # Build the witness-substituted harness and validate it under ASan.
    src = harness_source_for(harnesses_dir, pa_subdir.name)
    harness_text = src.read_text() if src is not None else ""
    replay_text  = harness_text
    witness_validation: dict = {"validated": False, "stage": "skipped"}
    if witness_args and harness_text:
        replay_text = render_replay_harness(harness_text, witness_args)
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            witness_validation = validate_replay(
                harness_text=replay_text,
                expected_file=asan["file"],
                expected_line=asan["line"],
                dataset_root=dataset_root,
                work_dir=Path(tmp),
            )
        if not witness_validation.get("validated"):
            # Fall back to the original (hard-coded) harness so the
            # shipped reproducer.c is still buildable + crashes.
            replay_text = harness_text

    fid = str(uuid.uuid4())
    eid = f"e_{uuid.uuid4().hex[:8]}"
    # Classification labels come from the manifest (ground truth) and the
    # rule's own metadata (@id, @name, @tags). Effect type and write
    # width are also declared by the rule via its @tags
    # (`effect/<type>`, `width/<bytes>`) — no hardcoded fallbacks here.
    bug_type     = (gt.get("bug_type") or "").strip() or rule_meta.get("name", "")
    bug_id       = gt.get("bug_id")
    rule_name    = (rule_meta.get("id") or "").strip()
    effect_type  = rule_meta.get("effect") or ""
    sanitizer_id = rule_meta.get("sanitizer") or ""
    width_str    = rule_meta.get("width") or ""
    try:
        write_width = int(width_str) if width_str else 0
    except ValueError:
        write_width = 0
    if not effect_type:
        raise SystemExit(f"rule {rule_name or '?'} is missing an @tags 'effect/<type>' "
                         f"declaration; cannot derive operation effect type")
    if not sanitizer_id:
        raise SystemExit(f"rule {rule_name or '?'} is missing an @tags "
                         f"'sanitizer/<name>' declaration")
    if write_width <= 0:
        raise SystemExit(f"rule {rule_name or '?'} is missing an @tags "
                         f"'width/<bytes>' declaration")
    func    = asan["function"]
    op_name = f"{effect_type}_at_{func}"

    # Derive the write-destination segment name from the actual source
    # line at (file, line). E.g. `block->header = ...` → segment
    # "block_header". This makes the WMI faithful to the specific bug
    # site rather than emitting a generic placeholder. We also capture
    # the full source line so a chainer can read the bug-firing statement
    # without having to fetch the source separately.
    dest_segment, dest_expr = derive_destination(
        dataset_root, asan["file"], asan["line"], effect_type=effect_type
    )
    source_excerpt = read_source_line(dataset_root, asan["file"], asan["line"])

    # The Operation Object lives inline at the WMI's top level (the
    # `operation` field), per the validator's expected layout. Per spec
    # the operation has `name`, `parameters`, `effects`, optional
    # `preconditions`. We carry an additional `parameter_names` extension
    # that maps each parameter slot to the KLEE-symbolic name referenced
    # in the SMT preconditions.
    # Per spec §"Parameter": each entry is an SMT-extended type
    # declaration for the operation's argument. We use a name+type form
    # ("int64 corrupt_size") so each parameter is self-describing — the
    # SMT preconditions reference these names directly (not the spec's
    # positional `ARG <n>` form, because KLEE emits SMT with the
    # symbolic-input names baked in).
    # Each LLM-derived parameter name in `parameters` gets a parallel
    # `parameters_meta` entry that anchors it to the source code:
    # which function it's an argument to, which parameter slot it fills,
    # or which memory location it's written to. Computed by static
    # parsing of the harness (no LLM dependency), so the *anchor* is
    # deterministic even when the symbol name itself is LLM-chosen.
    parameters_meta = derive_parameters_meta(
        harness_text=harness_text,
        dataset_root=dataset_root,
        witness_args=witness_args,
    )
    operation_obj = {
        "name":             op_name,
        "parameters":       [f"{a['type']} {a['name']}" for a in witness_args],
        "parameters_meta":  parameters_meta,
        "effects":    [{
            "type": effect_type,
            "id":   eid,
            "arguments": {
                "destinations": [dest_segment],
                "values":       [],
            },
        }],
        "preconditions":      smt_strings,
        "preconditions_meta": smt_meta,
    }
    memory_layout = [
        {"name":      dest_segment,
         "expr":      dest_expr,
         "locations": [{"offset": 0, "size": write_width}]},
    ]
    # WM §"Memory Relation": map memory_layout segments to concrete
    # symbols (and addresses where known) in the binary. We can't know
    # the runtime address of the OOB destination, but we ground the
    # segment to the symbol — the function whose body performs the write.
    memory_relation = {
        "segment": dest_segment,
        "symbol":  func,
    }

    # The wmi.json file follows the spec's "Weird Machine Instruction"
    # shape: exactly three top-level fields — `operation` (string,
    # referencing the operation_name), `trigger` (object), `name` (string).
    # All BREACH-specific data — including the operation's full definition
    # (with SMT preconditions) and the WMA-level memory layout — lives
    # under `metadata`. We do NOT emit `chains` here: chains belong to a
    # WMP, which is produced by a downstream chainer component that
    # consumes WMIs.
    # Per spec §"Trigger Object" the trigger has `function` and `file`.
    # We carry an `args` extension as well — the concrete KLEE-discovered
    # witness inputs that drive the harness through the trigger function
    # to the bug-firing call. This makes the trigger directly replayable:
    # a chainer / verifier can read args, plug them into reproducer.c,
    # and observe the same ASan crash.
    trigger = {"function": func, "file": asan["file"]}
    if witness_args:
        trigger["args"] = [
            {k: v for k, v in w.items() if k != "value_uint_le"}
            for w in witness_args
        ]

    wmi = {
        "operation": operation_obj,
        "trigger":   trigger,
        "name":      f"{(bug_type or 'Write-What-Where').replace(' ', '_')}-{func}-{fid[:8]}",
        "metadata": {
            "rule":            rule_name,
            "bug_type":        bug_type,
            "verdict_kind":    derive_verdict_kind(witness_validation, smt_strings),
            "crash_location":  {"file":     asan["file"],
                                "line":     asan["line"],
                                "function": func,
                                "source":   source_excerpt},
            # WMA-level memory layout + WM-level memory_relation,
            # embedded so the WMI is self-contained for downstream
            # chainers. NB: chains are intentionally NOT emitted —
            # those are produced by a separate chainer component that
            # consumes WMIs and emits WMPs.
            "memory_layout":        memory_layout,
            "memory_relation":      memory_relation,
            # Oracle results. The `oracle` field on each side names the
            # tool that actually produced the evidence — derived from the
            # rule's @tags (sanitizer/<x>) for the concrete oracle, and
            # the path_a directory layout (which symex tool produced
            # *.kquery / *.smt2 / *.ktest) for the symex oracle.
            "concrete_oracle": {
                "oracle":         f"{sanitizer_id}-userspace",
                "violation_type": asan["violation_type"],
                "exit_code":      _read_int(pa_subdir / "asan.exit"),
                "asan_excerpt":   asan["excerpt"],
                "harness_source": "reproducer.c",
                "harness_log":    "reproducer.log",
            },
            "symex_oracle": {
                "oracle":             _detect_symex_oracle(pa_subdir / "klee"),
                "tests":              _count_glob(pa_subdir / "klee", "*.ktest"),
                "ptr_errors":         _count_glob(pa_subdir / "klee", "*.ptr.err"),
                # Concrete witness inputs themselves live in trigger.args;
                # per-precondition metadata lives in operation.preconditions_meta;
                # here we record only the witness provenance + replay outcome.
                "witness_test":        witness_name,
                "witness_validation":  witness_validation,
            },
        },
    }

    fdir = out_dir / fid
    fdir.mkdir(parents=True, exist_ok=True)
    (fdir / "wmi.json").write_text(json.dumps(wmi, indent=2))
    (fdir / "reproducer.log").write_text(asan["full"])
    if replay_text:
        # If the witness validated, this is the witness-substituted
        # replay harness; otherwise it's the original harness.
        (fdir / "reproducer.c").write_text(replay_text)
    return fdir


def _detect_symex_oracle(klee_dir: Path) -> str:
    """Identify the symex tool by the artifacts present in `klee_dir`.
    KLEE leaves info / run.stats files; other tools would leave their
    own. Falls back to the directory's basename if unrecognized."""
    if not klee_dir.is_dir():
        return ""
    if (klee_dir / "info").is_file() or (klee_dir / "run.stats").is_file():
        return "klee"
    return klee_dir.name


def _read_int(p: Path) -> int | None:
    try:
        return int(p.read_text().strip())
    except (OSError, ValueError):
        return None


def _read_text(p: Path) -> str:
    try:
        return p.read_text().strip()
    except OSError:
        return ""


def _count_glob(d: Path, pat: str) -> int:
    return len(list(d.glob(pat))) if d.is_dir() else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n", 1)[0])
    ap.add_argument("--path-a",     type=Path, required=True,
                    help="out/repro/path_a/ (one subdir per harness run)")
    ap.add_argument("--codeql-csv", type=Path, required=True,
                    help="CodeQL bqrs decode CSV with the union of all rules' "
                         "hits (used for the harness-eligibility gate)")
    ap.add_argument("--manifest",   type=Path, default=None,
                    help="optional ground-truth manifest JSON. When supplied, "
                         "the row's bug_type overrides the rule's @name as the "
                         "human label.")
    ap.add_argument("--harnesses",  type=Path, required=True,
                    help="harness source dir (dataset/corpus/harnesses/)")
    ap.add_argument("--dataset-root", type=Path, required=True,
                    help="dataset/corpus/ root (used for ASan replay build)")
    ap.add_argument("--rule",       type=Path, default=None,
                    help="path to a single CodeQL rule .ql file (single-rule "
                         "mode — used as the fallback metadata source when "
                         "--rules-dir / --per-rule-csv-dir are not provided)")
    ap.add_argument("--rules-dir",  type=Path, default=None,
                    help="directory of generated CodeQL rules. Each rule's "
                         "metadata is parsed; the rule whose per-rule CSV "
                         "claims a given (file, line) crash supplies the "
                         "metadata for that finding's WMI.")
    ap.add_argument("--per-rule-csv-dir", type=Path, default=None,
                    help="directory of per-rule CSVs (one CSV per rule, "
                         "named <rule_stem>.csv). Required alongside "
                         "--rules-dir for multi-rule mode.")
    ap.add_argument("--out",        type=Path, required=True,
                    help="findings/ output dir; existing contents are wiped")
    args = ap.parse_args()

    if args.out.exists():
        shutil.rmtree(args.out)
    args.out.mkdir(parents=True)

    codeql_hits = load_codeql_hits(args.codeql_csv)
    manifest    = load_manifest(args.manifest) if args.manifest else {}

    # Multi-rule support: if a rules dir + per-rule CSV dir are passed,
    # build a (rule_stem -> meta) map and a (rule_stem -> hits) map so
    # we can attribute each crash to the rule that flagged it. Otherwise
    # fall back to the single --rule's metadata for every finding.
    fallback_meta: dict | None = None
    if args.rule is not None:
        fallback_meta = parse_rule_metadata(args.rule)
    rule_meta_by_stem = load_rule_meta_dir(args.rules_dir) if args.rules_dir else {}
    per_rule_hits = (
        load_per_rule_hits(args.per_rule_csv_dir) if args.per_rule_csv_dir else {}
    )

    if not args.path_a.is_dir():
        print(f"  ✗ no path_a dir at {args.path_a}", file=sys.stderr)
        return 2

    n_emitted = 0
    n_inspected = 0
    confirmed_keys: set[tuple[str, int]] = set()
    for sub in sorted(args.path_a.iterdir()):
        if not sub.is_dir():
            continue
        n_inspected += 1
        asan = parse_asan_log(sub / "asan.log")
        if asan is None:
            continue
        rule_meta = select_rule_meta_for(
            asan_key=(asan["file"], asan["line"]),
            fallback_meta=fallback_meta or {},
            per_rule_hits=per_rule_hits,
            rule_meta_by_stem=rule_meta_by_stem,
        )
        fdir = build_finding(
            pa_subdir=sub, asan=asan, codeql_hits=codeql_hits,
            manifest=manifest, harnesses_dir=args.harnesses,
            dataset_root=args.dataset_root,
            rule_meta=rule_meta,
            out_dir=args.out,
        )
        if fdir is not None:
            n_emitted += 1
            confirmed_keys.add((asan["file"], asan["line"]))
            print(f"  ✓ confirmed {asan['file']}:{asan['line']} "
                  f"in {asan['function']} → {fdir.name}")

    # Emit static-only candidates for every CodeQL hit not already covered
    # by a concrete-confirmed finding above. These are sites the rule
    # flagged but the harness pipeline couldn't ASan-validate (Claude
    # failed, KLEE didn't find a witness, etc.). The chainer still wants
    # to see them because the static signal is real evidence — it just
    # hasn't been concretized.
    n_static = 0
    for full_path, bug_file, bug_line in iter_codeql_hits(args.codeql_csv):
        if "/include/" in full_path or full_path.endswith(".h"):
            continue
        if (bug_file, bug_line) in confirmed_keys:
            continue
        rule_meta = select_rule_meta_for(
            asan_key=(bug_file, bug_line),
            fallback_meta=fallback_meta or {},
            per_rule_hits=per_rule_hits,
            rule_meta_by_stem=rule_meta_by_stem,
        )
        if rule_meta is None:
            continue
        fdir = emit_static_candidate_finding(
            bug_file=bug_file, bug_line=bug_line,
            rule_meta=rule_meta, dataset_root=args.dataset_root,
            out_dir=args.out,
        )
        if fdir is not None:
            n_static += 1

    print(f"  ✓ inspected {n_inspected} harness run(s); "
          f"emitted {n_emitted} concrete + {n_static} static-candidate "
          f"finding(s) in {args.out}")

    # Aggregate Archetype + Machine views across all confirmed findings.
    # The WMA defines abstract operations + the memory_layout they
    # reference; the WM grounds those segments to concrete symbols.
    # Emitted at the bundle level (alongside findings/) so a chainer
    # has both per-finding WMIs AND the aggregate map.
    emit_aggregate_views(args.out)
    return 0


def iter_codeql_hits(csv_path: Path):
    """Yield (full_path, basename, line) for each row in the union CSV."""
    if not csv_path.is_file():
        return
    for row in csv_path.read_text(errors="ignore").splitlines():
        m = CODEQL_HIT_RE.match(row)
        if not m:
            continue
        yield m.group("file"), Path(m.group("file")).name, int(m.group("line"))


def emit_static_candidate_finding(
    *,
    bug_file: str,
    bug_line: int,
    rule_meta: dict,
    dataset_root: Path,
    out_dir: Path,
) -> Path | None:
    """Emit a wmi.json for a CodeQL hit that didn't get an ASan-validated
    harness. Carries verdict_kind=static_candidate, no concrete_oracle,
    no symex_oracle. Source-derived destination + rule metadata only.
    No reproducer.c/log written (no harness available)."""
    rule_name    = (rule_meta.get("id") or "").strip()
    bug_type     = rule_meta.get("name", "") or "?"
    effect_type  = rule_meta.get("effect") or ""
    sanitizer_id = rule_meta.get("sanitizer") or ""
    width_str    = rule_meta.get("width") or ""
    if not (effect_type and sanitizer_id and width_str):
        return None
    try:
        write_width = int(width_str)
    except ValueError:
        return None

    dest_segment, dest_expr = derive_destination(
        dataset_root, bug_file, bug_line, effect_type=effect_type
    )
    source_excerpt = read_source_line(dataset_root, bug_file, bug_line)
    enclosing_fn = derive_enclosing_function(dataset_root, bug_file, bug_line)

    fid = str(uuid.uuid4())
    eid = f"e_{uuid.uuid4().hex[:8]}"
    op_name = (f"{effect_type}_at_{enclosing_fn}"
               if enclosing_fn != "?" else f"{effect_type}_at_line{bug_line}")
    operation_obj = {
        "name":             op_name,
        "parameters":       [],
        "parameters_meta":  [],
        "effects":    [{
            "type": effect_type,
            "id":   eid,
            "arguments": {
                "destinations": [dest_segment],
                "values":       [],
            },
        }],
        "preconditions":      [],
        "preconditions_meta": [],
    }
    memory_layout = [
        {"name":      dest_segment,
         "expr":      dest_expr,
         "locations": [{"offset": 0, "size": write_width}]},
    ]
    memory_relation = {"segment": dest_segment, "symbol": "?"}

    wmi = {
        "operation": operation_obj,
        "trigger":   {"function": enclosing_fn, "file": bug_file},
        "name":      f"{bug_type.replace(' ', '_')}-line{bug_line}-{fid[:8]}",
        "metadata": {
            "rule":            rule_name,
            "bug_type":        bug_type,
            "verdict_kind":    "static_candidate",
            "crash_location":  {"file": bug_file, "line": bug_line,
                                "function": enclosing_fn, "source": source_excerpt},
            "memory_layout":        memory_layout,
            "memory_relation":      memory_relation,
            # No concrete or symex evidence at this tier — the static
            # rule fired but no validating harness was produced.
            "concrete_oracle": {"oracle": f"{sanitizer_id}-userspace",
                                "violation_type": None,
                                "exit_code": None,
                                "asan_excerpt": "",
                                "harness_source": None,
                                "harness_log":    None},
            "symex_oracle":    {"oracle": "klee", "tests": 0, "ptr_errors": 0,
                                "witness_test": None,
                                "witness_validation": {"validated": False,
                                                        "stage": "skipped"}},
        },
    }

    fdir = out_dir / fid
    fdir.mkdir(parents=True, exist_ok=True)
    (fdir / "wmi.json").write_text(json.dumps(wmi, indent=2))
    return fdir


def emit_aggregate_views(findings_dir: Path) -> None:
    """Walk findings/<uuid>/wmi.json and emit:
       <bundle>/wma.json   — aggregated Weird Machine Archetype
       <bundle>/wm.json    — aggregated Weird Machine (instructions
                              + memory_relations list)
    where <bundle> is findings_dir.parent."""
    operations: list[dict] = []
    seen_op_keys: set[str] = set()
    segments: dict[str, dict] = {}
    instructions: list[dict] = []
    relations: list[dict] = []
    for sub in sorted(findings_dir.iterdir()):
        if not sub.is_dir():
            continue
        wmi_path = sub / "wmi.json"
        if not wmi_path.is_file():
            continue
        try:
            wmi = json.loads(wmi_path.read_text())
        except json.JSONDecodeError:
            continue
        op = wmi.get("operation") or {}
        # Dedup operations by (name, parameters, effect signatures).
        key = json.dumps([
            op.get("name"),
            op.get("parameters"),
            [(e.get("type"),
              tuple((e.get("arguments") or {}).get("destinations", [])))
             for e in (op.get("effects") or [])],
        ], sort_keys=True)
        if key not in seen_op_keys:
            operations.append(op)
            seen_op_keys.add(key)
        for seg in (wmi.get("metadata") or {}).get("memory_layout", []) or []:
            name = seg.get("name")
            if name and name not in segments:
                segments[name] = seg
        instructions.append({
            "operation": op.get("name"),
            "trigger":   wmi.get("trigger"),
            "name":      wmi.get("name"),
            "wmi_path":  f"findings/{sub.name}/wmi.json",
        })
        rel = (wmi.get("metadata") or {}).get("memory_relation")
        if rel:
            relations.append(rel)

    bundle_root = findings_dir.parent
    (bundle_root / "wma.json").write_text(json.dumps({
        "memory_layout": list(segments.values()),
        "operations":    operations,
    }, indent=2))
    # Spec WM has a single `memory_relation: object`; we extend it to
    # `memory_relations: array` since one WM covers multiple WMIs.
    (bundle_root / "wm.json").write_text(json.dumps({
        "archetype":           "wma.json",
        "instructions":        instructions,
        "memory_relations":    relations,
    }, indent=2))
    print(f"  ✓ emitted {bundle_root}/wma.json "
          f"({len(operations)} unique op(s), {len(segments)} segment(s)) "
          f"+ {bundle_root}/wm.json ({len(instructions)} instruction(s))")


if __name__ == "__main__":
    sys.exit(main())
