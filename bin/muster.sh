#!/usr/bin/env bash
# muster.sh — 동반 하네스 정렬(Muster) + gemini(Cohort) 규율 셋업을 Cohort에 위임.
# Magos(Claude)는 직접 시스템을 만지지 않는다: Cohort(Gemini)가 셋업 산출물을 Forge에 빚고,
# Magos가 Sanction(검토)한 뒤 적용한다. 무검토 반영 0. never-yolo(= Abominable Intelligence 금단).
#
# 사용: bin/muster.sh
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
PARENT="$(cd "$ROOT/.." && pwd)"

CLAUDE="$PARENT/please-work-claude"
GEMINI="$PARENT/please-work-gemini"

echo "== Muster: 동반 하네스 점검 =="
status () { [[ -d "$1" ]] && echo "  [OK]   $2" || echo "  [없음] $2 (클론 필요)"; }
status "$CLAUDE" "please-work-claude (Magos 규율) — $CLAUDE"
status "$GEMINI" "please-work-gemini (Cohort 규율) — $GEMINI"
echo "  [OK]   please-work-clemini (Legio Cybernetica 위임 층) — $ROOT"
echo ""

if [[ ! -d "$GEMINI" ]]; then
  cat <<MSG
[중단] please-work-gemini 클론이 없다. 먼저 받아라:
  git -C "$PARENT" clone https://github.com/Whe-Yo/please-work-gemini.git
그 후 bin/muster.sh 재실행.
MSG
  exit 2
fi

echo "== Cohort(Gemini)에 gemini 규율 셋업 위임 → Forge 산출 =="
echo "   (Magos는 시스템 직접 편집 안 함. Gemini가 Forge에만 절차·초안 작성.)"
echo ""

DOCTRINA="[역할] 너는 Cohort. please-work-gemini 하네스를 현재 Gemini(Antigravity) 환경에 장착하는 셋업 절차를 산출하라.
[입력] 하네스 소스: ${GEMINI} (rules/AGENTS.md, skills/, mcp/ 를 읽기만. 수정 금지).
[산출물 — 현재 작업 디렉토리(Forge)에 파일로]
  1) SETUP_STEPS.md : 단계별 장착 체크리스트(각 단계에 대상 경로·명령·검증 방법).
  2) 필요한 설정 파일 초안(있으면).
[제약]
  - 시스템·홈 디렉토리를 직접 수정하지 마라. Forge에 '절차와 초안'만 써라.
  - 비밀(.env·토큰) 포함 금지.
  - 추정 말고 소스에 있는 사실만. 모르면 'UNKNOWN'으로 표기.
[종료조건] SETUP_STEPS.md 작성 완료하면 멈춰라."

# Forge에 산출(검토 전 본 프로젝트 미적용). delegate.sh가 gemini_workspace/<세션>에 격리.
"$DIR/delegate.sh" --mode plan --workspace --brief "$DOCTRINA"

cat <<'SANCTION'

== Sanction (Magos 검토 게이트) — 적용 전 필수 ==
  1) 위 [workspace] 경로의 SETUP_STEPS.md를 Magos(Claude)가 검토.
  2) 위험 단계(시스템 수정·권한·네트워크) 가려내고, 경로·명령을 사실 검증.
  3) 통과한 단계만 Magos가 직접 적용(또는 사용자가 실행). Cohort 산출을 무검토로 반영 금지.
  4) Magos 하네스(claude)는 please-work-claude의 `setup` 스킬로 Claude가 직접 장착(Cohort 위임 아님).
  5) 마찰·결함은 Datavault(log_for_test/)에 피드백으로 남긴다.
SANCTION
