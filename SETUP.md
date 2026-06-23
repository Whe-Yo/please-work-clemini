# SETUP — Muster (통합 셋업)

clemini는 **Legio Cybernetica** 위임 층이다. 단독으로 동작하지 않고, 두 동반 하네스가 함께 정렬(Muster)돼야 한다.

## 동반 하네스
- **please-work-claude** — Magos(Claude·머리) 규율: boost·RPW·antithesis. Claude 런타임에 장착.
- **please-work-gemini** — Cohort(Gemini·손) 규율. Gemini(Antigravity) 런타임에 장착.
- **please-work-clemini** — 이 저장소. Magos↔Cohort 위임(`delegate.sh`·Maniple·Forge·Sanction).

## Muster 흐름 — `bin/muster.sh`
"please-work-gemini 설치"는 셋을 함께 세우라는 신호다.

1. 세 저장소(클론) 존재 점검 — 없으면 클론 안내.
2. **gemini(Cohort) 규율 셋업을 Cohort(Gemini)에 위임** — `delegate.sh --workspace`로 Gemini가 셋업 절차(`SETUP_STEPS.md`)·초안을 **Forge(`gemini_workspace/<세션>`)에만** 산출.
3. **Sanction** — Magos(Claude)가 Forge 산출을 검토·검증한 뒤에만 적용. 무검토 반영 0.

## 왜 gemini 셋업을 Cohort에 위임하나
gemini 하네스는 **Gemini 자신의 런타임**을 다룬다 → 그 환경을 가장 잘 아는 Cohort가 1차 절차를 빚는 게 맞다(잉여 Gemini 토큰 활용). 단 Cohort 산출은 **항상 Sanction 게이트**를 통과해야 한다. "잘 할지" 걱정은 이 게이트가 받는다.

## 안전 — never-yolo (= Abominable Intelligence 금단)
- agy는 안전한 헤드리스 파일편집 모드가 없다(유일 자동승인 = `--dangerously-skip-permissions` = yolo). 따라서 Cohort에 **시스템 직접 편집을 위임하지 않는다.** 산출은 Forge, 적용은 Magos(또는 사용자).
- Magos(claude) 규율 장착은 please-work-claude의 `setup` 스킬로 Claude가 직접 한다 — Cohort에 위임하지 않는다.

## Magos(claude) 하네스 셋업
please-work-claude의 `setup` 스킬을 Claude가 실행 → `rules/CLAUDE.md` 주입 + 스킬 장착. clemini는 그 위에서 위임 층으로 동작한다.
