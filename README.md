# harden_eval2_stase3_run

stase3 on HARDEN eval2 Linux — 6 LLM harnesses, 6 KLEE crash witnesses.

Toolchain: the upstream stase3 Docker image (`stase3:1.0.0`, built from the [stase3 repo](https://repo.iti.illinois.edu/harden/harden-ta1-emergency/eval3_demo/-/tree/main/stase3?ref_type=heads)'s `Dockerfile`) bundles codeql, klee, clang-14, gcc.

## Run KLEE on the cached harnesses

```bash
KLEE_BIN=/path/to/klee/build/bin/klee \
KLEE_INC=/path/to/klee/include \
OUT=results scripts/run_path_a_eval2.sh
```

Outputs under `results/path_a/<bug>/klee/` — `*.ktest`, `*.smt2`, `*.ptr.err` / `*.div.err`.
