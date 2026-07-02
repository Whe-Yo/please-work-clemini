#!/usr/bin/env bash
# delegate-fanout.sh — 여러 '파티션된' 명세를 Gemini에 동시 위임(병렬 팬아웃).
# 잉여 Gemini를 유휴 없이 굴린다: Claude가 호출자에서 이 스크립트를 백그라운드로 띄우면
# (run_in_background) Claude가 다른 작업을 하는 동안 N개 Gemini 세션이 병렬로 돈다.
#
# 원칙: 각 명세는 독립(중복 연산 금지). 결과는 명세별로 구분해 모아 출력 → Claude가 통합.
# 사용: delegate-fanout.sh [--refine N] [--brief] [--model M | --deep] "spec1" "spec2" ...
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=()
SPECS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --refine)    PASS+=(--refine "$2"); shift 2 ;;
    --brief)     PASS+=(--brief);       shift ;;
    --model)     PASS+=(--model "$2");  shift 2 ;;
    --deep)      PASS+=(--deep);        shift ;;
    --workspace) PASS+=(--workspace);   shift ;;
    --*)         echo "알 수 없는 옵션: $1" >&2; exit 2 ;;
    *)        SPECS+=("$1");         shift ;;
  esac
done
[[ ${#SPECS[@]} -ge 1 ]] || { echo "사용: delegate-fanout.sh [--refine N] [--brief] \"spec1\" \"spec2\" ..." >&2; exit 2; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# 각 파티션을 백그라운드로 동시 실행 (각각 독립 Gemini 세션)
i=0
PIDS=()
for s in "${SPECS[@]}"; do
  i=$((i + 1))
  "$DIR/delegate.sh" --mode plan ${PASS[@]+"${PASS[@]}"} "[파티션 ${i}/${#SPECS[@]} — 너는 이 명세 범위만 담당한다. 다른 파티션과 겹치는 작업·범위 밖 탐색 금지(중복=낭비).]
${s}" >"$tmp/out_$i" 2>"$tmp/err_$i" &
  PIDS+=($!)
done
# 파티션별 종료코드 수집 — 일괄 wait는 실패를 삼킨다(260702 안티테제: 모델 거부·agy 실패 파티션이
# '정상 헤더 + 빈 본문'으로 침묵 통과 → Magos가 결손을 모름).
RCS=()
for pid in "${PIDS[@]}"; do
  rc=0; wait "$pid" || rc=$?
  RCS+=("$rc")
done

# 결과를 파티션별로 모아 출력. 실패 파티션은 stderr 전체를 표면화(침묵 금지).
FAILS=0
i=0
for s in "${SPECS[@]}"; do
  i=$((i + 1))
  rc="${RCS[$((i - 1))]}"
  if [[ "$rc" -ne 0 ]]; then
    FAILS=$((FAILS + 1))
    printf '\n===== [파티션 %d — !! 실패 (exit %s): 결과 없음 — 채택 금지, 아래 stderr 확인 후 재하달] =====\n' "$i" "$rc"
    cat "$tmp/err_$i"
    continue
  fi
  if grep -q '^>>> ESCALATE TO MAGOS' "$tmp/out_$i" 2>/dev/null; then
    printf '\n===== [파티션 %d — !! ESCALATION: Magos 처리 필요] =====\n' "$i"
  else
    printf '\n===== [파티션 %d] =====\n' "$i"
  fi
  grep -h "\[workspace\]" "$tmp/err_$i" 2>/dev/null || true
  cat "$tmp/out_$i"
done
# 하나라도 실패면 비정상 종료 — 호출자(Magos)가 놓치지 않게.
[[ "$FAILS" -eq 0 ]] || { printf '\n[fanout] 파티션 %d/%d 실패 — 실패분 재하달 필요.\n' "$FAILS" "${#SPECS[@]}"; exit 1; }
