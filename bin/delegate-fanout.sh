#!/usr/bin/env bash
# delegate-fanout.sh — 여러 '파티션된' 명세를 Gemini에 동시 위임(병렬 팬아웃).
# 잉여 Gemini를 유휴 없이 굴린다: Claude가 호출자에서 이 스크립트를 백그라운드로 띄우면
# (run_in_background) Claude가 다른 작업을 하는 동안 N개 Gemini 세션이 병렬로 돈다.
#
# 원칙: 각 명세는 독립(중복 연산 금지). 결과는 명세별로 구분해 모아 출력 → Claude가 통합.
# 사용: delegate-fanout.sh [--refine N] [--brief] [--model M] "spec1" "spec2" ...
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=()
SPECS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --refine)    PASS+=(--refine "$2"); shift 2 ;;
    --brief)     PASS+=(--brief);       shift ;;
    --model)     PASS+=(--model "$2");  shift 2 ;;
    --workspace) PASS+=(--workspace);   shift ;;
    --*)         echo "알 수 없는 옵션: $1" >&2; exit 2 ;;
    *)        SPECS+=("$1");         shift ;;
  esac
done
[[ ${#SPECS[@]} -ge 1 ]] || { echo "사용: delegate-fanout.sh [--refine N] [--brief] \"spec1\" \"spec2\" ..." >&2; exit 2; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# 각 파티션을 백그라운드로 동시 실행 (각각 독립 Gemini 세션)
i=0
for s in "${SPECS[@]}"; do
  i=$((i + 1))
  "$DIR/delegate.sh" --mode plan ${PASS[@]+"${PASS[@]}"} "$s" >"$tmp/out_$i" 2>"$tmp/err_$i" &
done
wait

# 결과를 파티션별로 모아 출력
i=0
for s in "${SPECS[@]}"; do
  i=$((i + 1))
  printf '\n===== [파티션 %d] =====\n' "$i"
  grep -h "\[workspace\]" "$tmp/err_$i" 2>/dev/null || true
  cat "$tmp/out_$i"
done
