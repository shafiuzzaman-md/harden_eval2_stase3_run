#!/usr/bin/env bash
# Path-A driver for the eval2 linux reproduction.
#
# Same shape as scripts/run_path_a.sh, but reads from out/eval2_linux/
# instead of dataset/corpus/. For each generated harness:
#   1. Build with gcc -fsanitize=address,undefined and run; capture log.
#   2. Build with clang-14 -emit-llvm to bitcode under -D__KLEE__ and run KLEE
#      with --max-time and --write-smt2s; collect ktests + ptr.err witnesses.
#
# Outputs per harness:
#   out/eval2_linux/path_a/<name>/
#       harness            ASan+UBSan binary
#       asan.log           ASan/UBSan trip log
#       asan.exit          exit code from the ASan run
#       harness.bc         LLVM bitcode for KLEE
#       klee/              KLEE working dir (ktests, .smt2, .ptr.err, etc.)
#       klee.log           KLEE stdout/stderr

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "${HERE}/.." && pwd)"
DATASET="${REPO}/out/eval2_linux"
OUT="${OUT:-${DATASET}}"
PA="${OUT}/path_a"
HARNESSES_DIR="${DATASET}/harnesses"
mkdir -p "${PA}"

KLEE_BIN="${KLEE_BIN:-/home/shafi/tools/klee/build/bin/klee}"
KLEE_INC="${KLEE_INC:-/home/shafi/tools/klee/include}"
CLANG="${CLANG:-clang-14}"
CC="${CC:-gcc}"
KLEE_TIMEOUT="${KLEE_TIMEOUT:-30s}"

command -v "${CC}" >/dev/null 2>&1 || { echo "ERROR: ${CC} not on PATH"; exit 2; }
HAS_CLANG=0; command -v "${CLANG}" >/dev/null 2>&1 && HAS_CLANG=1
HAS_KLEE=0
if [ -x "${KLEE_BIN}" ] && [ -d "${KLEE_INC}" ] && [ "${HAS_CLANG}" = 1 ]; then HAS_KLEE=1; fi

CFLAGS_COMMON="-g -O0 -w -I ${DATASET}/src/include -I ${DATASET}/src"
SAN_FLAGS="-fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer"

run_one() {
    local name="$1"
    local src="${HARNESSES_DIR}/harness_${name}.c"
    local d="${PA}/${name}"
    mkdir -p "${d}"
    [ -f "${src}" ] || { echo "  ✗ missing: ${src}"; return 1; }

    # 1. concrete sanitizer build + run
    echo "${CC} ${CFLAGS_COMMON} ${SAN_FLAGS} ${src} -o ${d}/harness" > "${d}/build.cmd"
    if ! ${CC} ${CFLAGS_COMMON} ${SAN_FLAGS} "${src}" -o "${d}/harness" 2> "${d}/build.log"; then
        echo "  ✗ ${name}: build failed (see ${d}/build.log)"
        return 0
    fi
    set +e
    UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1 "${d}/harness" \
        > "${d}/asan.log" 2>&1
    local rc=$?
    set -e
    echo "${rc}" > "${d}/asan.exit"
    if grep -qE 'AddressSanitizer|runtime error' "${d}/asan.log"; then
        local hit
        hit=$(grep -m1 -oE '[a-zA-Z_./]+\.c:[0-9]+' "${d}/asan.log" || true)
        echo "  ✓ ${name}: sanitizer trip @ ${hit} (exit ${rc})"
    else
        echo "  ⚠ ${name}: sanitizer did NOT fire (exit ${rc})"
    fi

    # 2. KLEE bitcode + run
    if [ "${HAS_KLEE}" = 1 ]; then
        if ! ${CLANG} -emit-llvm -c ${CFLAGS_COMMON} -D__KLEE__ -I "${KLEE_INC}" \
              "${src}" -o "${d}/harness.bc" 2>> "${d}/build.log"; then
            echo "    ⚠ ${name}: bitcode build failed"
            return 0
        fi
        rm -rf "${d}/klee"
        set +e
        "${KLEE_BIN}" --output-dir="${d}/klee" \
            --max-time="${KLEE_TIMEOUT}" \
            --only-output-states-covering-new \
            --write-smt2s --smtlib-human-readable \
            "${d}/harness.bc" > "${d}/klee.log" 2>&1
        set -e
        local n_tests n_errs
        n_tests=$(ls "${d}/klee/"*.ktest 2>/dev/null | wc -l | tr -d ' ')
        n_errs=$(ls "${d}/klee/"*.err 2>/dev/null | wc -l | tr -d ' ')
        echo "    KLEE: ${n_tests} ktest(s), ${n_errs} error witness(es)"
    fi
}

echo "============================================================"
echo "Path A — eval2 linux concrete confirmation"
echo "============================================================"
echo "  harnesses: ${HARNESSES_DIR}"
echo "  output:    ${PA}"
echo

shopt -s nullglob
declare -a names=()
for f in "${HARNESSES_DIR}"/harness_*.c; do
    name="$(basename "${f}" .c)"
    name="${name#harness_}"
    [ -n "${name}" ] || continue
    names+=("${name}")
done
[ "${#names[@]}" -eq 0 ] && { echo "  ✗ no harnesses found"; exit 1; }
echo "  running ${#names[@]} harness(es)..."
echo

set +e
for name in "${names[@]}"; do run_one "${name}"; done
set -e

# summary
{
    echo "Path A — eval2 summary"
    echo "ts: $(date -Is)"
    for d in "${PA}"/*/; do
        [ -d "${d}" ] || continue
        n="$(basename "${d}")"
        [ -f "${d}/asan.exit" ] || continue
        rc=$(cat "${d}/asan.exit")
        ktests=$(ls "${d}/klee/"*.ktest 2>/dev/null | wc -l | tr -d ' ')
        errs=$(ls "${d}/klee/"*.err 2>/dev/null | wc -l | tr -d ' ')
        echo "  ${n}: asan_exit=${rc}  klee_tests=${ktests}  klee_errs=${errs}"
    done
} > "${PA}/summary.txt"
cat "${PA}/summary.txt"
