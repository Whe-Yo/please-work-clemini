# Please-Work Clemini

**Claude(머리) + Gemini(손)** 오케스트레이션. Claude가 명세·검토를 맡고, 실제 대량 실행은 Gemini에 `agy` CLI로 위임한다. 사람이 "RPW 만들어 → 제미나이한테 붙여넣어"를 반복하던 **수동 중계를 제거**하는 게 목적.

> [please-work](https://github.com/Whe-Yo/please-work-claude) 가족: [claude](https://github.com/Whe-Yo/please-work-claude)(Claude 하네스) · [gemini](https://github.com/Whe-Yo/please-work-gemini)(제미나이 변형) · **clemini**(Claude×Gemini 오케스트레이션).

---

## 이 프로젝트의 의의

### 1. 역할 분리 — 머리와 손 (Gemini는 폭넓게)
- **Claude = 머리**: 닫힌 명세 작성, 최종 판단·치명적 검증. 판단 집약적·저용량. 토큰 **효율화**(중복·장황 배제).
- **Gemini = 손이자 1차 검토자**: 조사·자료수집·코드탐색·대량 실행 **+ 1차 논리 검증(안티테제)**. 가성비가 좋으니 **아끼지 않고** 1차 일을 넓게 맡긴다.
- 비싼 모델은 적은 토큰(명세·최종판단)에, 싼 모델은 많은 토큰(조사·실행·1차반론)에 — **cost-aware sandwich**.
- 라우팅 표는 [`rules/AGENTS.md`](rules/AGENTS.md).

### 2. agy CLI 메커니즘 (✅ 동작 검증됨)
Claude Code가 셸로 `agy --print "<명세>"`를 호출해 Gemini를 헤드리스로 돌리고, 결과를 받아 검증한다. GUI·마우스 없이. (`bin/delegate.sh`가 래핑.)
- **`plan` (읽기·추론)**: `agy --print` — 권한 자동승인 안 줌 → 위험 도구 막힘. 조사·분석·1차 안티테제에 사용. **단 `--print`도 cwd에 파일을 쓸 수 있다**(실증: RPW를 수정함) → delegate.sh가 **격리 임시 디렉토리에서 실행**해 실제 파일 오염 차단.
- **`auto_edit` (파일 편집)**: agy는 안전한 세밀 편집 모드가 없다(유일한 자동승인 `--dangerously-skip-permissions`=전체=yolo). → **agy로는 헤드리스 편집 미지원.** 편집은 IDE에서 직접 하거나 Claude가 한다.
- **`--dangerously-skip-permissions`(=yolo) 절대 금지** — 승인 게이트를 없애면 폭주(omega 루프)가 돌아온다.

> **쿼터**: `agy`는 데스크탑/IDE와 **같은 구독 쿼터**를 공유한다(별도 AI 크레딧 아님). 호출당 ~23–25k 토큰 오버헤드가 있으나 **Ultra 기준 여유 충분**. 그래도 "호출은 묶어 크게"가 낭비 방지에 좋다.

### 3. RPW = 머리↔손 계약서
명세는 RPW의 Plan에 **닫힌 형태**로(종료조건 명시, "개선/최적화" 같은 열린 동사 금지). Gemini가 읽고 실행 → 결과를 Work에. Claude가 검토 → 다음 Plan.

---

## 사용

```sh
# 조사 위임 (Gemini가 1차 일꾼 — 한 번에 크게)
bin/delegate.sh --mode plan "이 코드베이스에서 X 기능의 구현 위치·의존성·한계를 파일·라인으로 정리해 보고. 수정 금지."

# 1차 논리 검증/안티테제 위임 (Gemini가 1차 검토자 — Claude가 최종 통합)
bin/delegate.sh --mode plan "아래 설계의 논리 결함·누락·과도한 가정만 비판해 보고. 칭찬 금지: {설계 내용}"
```

> 파일 편집은 agy 헤드리스로 안전히 안 되므로(위 2번 참고) Claude가 직접 하거나 IDE에서 한다. clemini는 **조사·분석·1차 안티테제 위임**에 집중.

clemini는 **agy 전용**입니다. `agy` 미설치 시 delegate.sh가 설치를 요청합니다(gemini 폴백 없음): `curl -fsSL https://antigravity.google/cli/install.sh | sh`.

---

## 규칙
오케스트레이션 규율은 [`rules/AGENTS.md`](rules/AGENTS.md). 핵심: 닫힌 명세 · never yolo · Claude가 검증.

---

## 실증·피드백 로그 ([log_for_test/](log_for_test/))
실사용 중 발견한 버그·마찰·개선점을 md로 남기는 영역. 형식은 [`FEEDBACK_TEMPLATE.md`](log_for_test/FEEDBACK_TEMPLATE.md). 파일명 `YYMMDD_HHMM_{에이전트}_feedback.md`. 버전 이력은 [CHANGELOG.md](CHANGELOG.md).
