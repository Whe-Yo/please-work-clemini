#!/usr/bin/env bash
# delegate.sh — Claude(머리)가 Gemini(손)에 작업을 위임하는 래퍼.
# Antigravity CLI(agy)를 헤드리스로 호출하고 결과를 stdout으로 돌려준다.
#
# 사용:
#   bin/delegate.sh [--mode plan|auto_edit] [--dir PATH] "닫힌 명세 (종료조건 포함)"
#
# 모드:
#   plan       읽기·추론·조사·1차 안티테제 (안전 기본). 파일 수정 안 함.
#   auto_edit  좁은 파일 편집. agy는 안전한 세밀 모드가 없어 미지원(아래 참고).

set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
MODE="plan"
DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    --dir)  DIR="$2";  shift 2 ;;
    --*)    echo "알 수 없는 옵션: $1" >&2; exit 2 ;;
    *)      SPEC="$1"; shift ;;
  esac
done

[[ "$MODE" == "plan" || "$MODE" == "auto_edit" ]] || { echo "거부: --mode는 plan 또는 auto_edit." >&2; exit 2; }
[[ -n "${SPEC:-}" ]] || { echo "사용: bin/delegate.sh [--mode plan|auto_edit] [--dir PATH] \"명세\"" >&2; exit 2; }

# agy 전용. 없으면 설치 요청(gemini 폴백 안 함).
if ! command -v agy >/dev/null 2>&1; then
  cat >&2 <<'MSG'
거부: agy(Antigravity CLI) 미설치. clemini는 agy 전용입니다.

설치:
  curl -fsSL https://antigravity.google/cli/install.sh | sh

설치 후 `agy` 첫 실행 시 구글 로그인(Ultra 계정)으로 인증하세요.
MSG
  exit 127
fi

[[ -n "$DIR" ]] && cd "$DIR"

# never yolo — agy의 --dangerously-skip-permissions는 절대 안 쓴다(폭주 방지).
case "$MODE" in
  # 읽기·추론. 권한 자동승인 플래그를 주지 않는다 → 위험 도구는 막힘(안전).
  plan)
    # agy는 복잡 산출물을 stdout이 아니라 아티팩트 .md 파일에 쓰고 포인터만 출력한다.
    # 출력을 캡처해 그대로 보여주고, 아티팩트 경로가 있으면 본문을 회수해 덧붙인다.
    OUT="$(agy --print "$SPEC")"
    printf '%s\n' "$OUT"
    ART="$(printf '%s' "$OUT" | grep -oE '/[^[:space:])"]*antigravity-cli/brain/[^[:space:])"]*\.md' | head -1)"
    if [[ -n "$ART" && -f "$ART" ]]; then
      printf '\n===== [아티팩트 회수: %s] =====\n' "$ART"
      cat "$ART"
    fi
    ;;
  # agy는 세밀한 "편집만 자동" 모드가 없다. 유일한 자동승인이
  # --dangerously-skip-permissions(전체=yolo)라 금지. 편집은 IDE에서 직접 하거나 Claude가.
  auto_edit) echo "거부: agy는 안전한 세밀 편집 위임 모드가 없다(유일한 자동승인=--dangerously-skip-permissions=yolo, 금지). 편집은 IDE/Claude로." >&2; exit 2 ;;
esac
