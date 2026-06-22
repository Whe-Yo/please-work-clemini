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
MODEL="Gemini 3.1 Pro (High)"   # 항상 최신 Gemini Pro (사용자 지시). --model로 override.
REFINE=1                        # 다중패스 자기개선 횟수(성능↑). --refine N (잉여 Gemini 활용).
BRIEF=""                        # 결정가능 압축출력(Claude 읽기↓). --brief.

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)   MODE="$2";   shift 2 ;;
    --dir)    DIR="$2";    shift 2 ;;
    --model)  MODEL="$2";  shift 2 ;;
    --refine) REFINE="$2"; shift 2 ;;
    --brief)  BRIEF=1;     shift ;;
    --*)      echo "알 수 없는 옵션: $1" >&2; exit 2 ;;
    *)        SPEC="$1";   shift ;;
  esac
done

[[ "$MODE" == "plan" || "$MODE" == "auto_edit" ]] || { echo "거부: --mode는 plan 또는 auto_edit." >&2; exit 2; }
[[ "$REFINE" =~ ^[1-9]$ ]] || { echo "거부: --refine는 1~9 정수(무한 자기개선 루프 방지)." >&2; exit 2; }
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

# agy --print는 "읽기전용"이 아니다 — 실증: cwd의 rule_plan_work.md를 자기 작업로그로 수정함.
# 따라서 --dir 미지정 시 격리된 임시 디렉토리에서 실행해 실제 파일 오염을 차단한다.
if [[ -n "$DIR" ]]; then
  cd "$DIR"
else
  _SANDBOX="$(mktemp -d)"; trap 'rm -rf "$_SANDBOX"' EXIT; cd "$_SANDBOX"
fi

# never yolo — agy의 --dangerously-skip-permissions는 절대 안 쓴다(폭주 방지).

# agy 1회 호출 + 아티팩트 본문 인라인 회수(복잡 산출물은 stdout 아닌 .md 파일에 씀).
_run_agy() {
  local out art
  out="$(agy --model "$MODEL" --print "$1")"
  art="$(printf '%s' "$out" | grep -oE '/[^[:space:])"]*antigravity-cli/brain/[^[:space:])"]*\.md' | head -1)"
  if [[ -n "$art" && -f "$art" ]]; then cat "$art"; else printf '%s' "$out"; fi
}

case "$MODE" in
  # 읽기·추론. 위험 도구는 막히나 cwd 파일 쓰기는 가능 → 위 샌드박스로 격리.
  plan)
    FMT=""
    [[ -n "$BRIEF" ]] && FMT=$'\n\n[형식] 결정 가능한 형태로 압축: 서론·칭찬·반복 금지, 구조적 불릿, 결론 먼저.'
    CUR="$(_run_agy "${SPEC}${FMT}")"
    # 다중패스 자기개선: 직전 결과를 비판·개선(올바른 부분 보존). 잉여 Gemini로 품질↑.
    i=1
    while (( i < REFINE )); do
      CUR="$(_run_agy "아래 결과를 비판적으로 검토해 결함·누락·과장·오류만 고치고 더 정확·완결하게 개선한 최종본만 출력. 올바른 부분은 보존(불필요한 재작성 금지). 칭찬·메타설명 금지.${FMT}

[직전 결과]
${CUR}")"
      ((i++))
    done
    printf '%s\n' "$CUR"
    ;;
  # agy는 세밀한 "편집만 자동" 모드가 없다. 유일한 자동승인이
  # --dangerously-skip-permissions(전체=yolo)라 금지. 편집은 IDE에서 직접 하거나 Claude가.
  auto_edit) echo "거부: agy는 안전한 세밀 편집 위임 모드가 없다(유일한 자동승인=--dangerously-skip-permissions=yolo, 금지). 편집은 IDE/Claude로." >&2; exit 2 ;;
esac
