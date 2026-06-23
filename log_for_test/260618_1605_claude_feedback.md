# Feedback — 260618_1605 / claude

> 원래 please-work-claude에 기록됐던 clemini 피드백. clemini에 `log_for_test/`가 생기면서 260623 이전. 대상: please-work-clemini.

---

## [BUG-1] agy CLI 미설치 — delegate.sh 동작 불완전

### 유형
bug

### 요약
`agy` CLI 미설치 환경에서 delegate.sh의 기본 동작이 차단됨. gemini fallback은 수동 환경변수 설정 필요.

### 무슨 일이
- **하려던 것**: `bin/delegate.sh`로 Gemini에 작업 위임
- **일어난 것**: `agy` 없음 → `command -v agy` 실패 → exit 127. `CLEMINI_CLI=gemini`로 우회 필요.
- **기대한 것**: fallback이 자동으로 감지·적용되거나, 설치 안내 출력

### 환경
- 에이전트: Claude Code (claude-sonnet-4-6)
- OS: Linux (workspace 환경)
- agy: 미설치, gemini CLI: `/usr/local/bin/gemini` 존재

### 재현
1. `bin/delegate.sh --mode plan "테스트"` 실행
2. `거부: 'agy' 미설치.` 출력 후 exit 127

### 관련 스킬·규칙
- `bin/delegate.sh`: `CLI="${CLEMINI_CLI:-agy}"` — 기본값이 agy
- README: "`agy` 미설치 시 `CLEMINI_CLI=gemini bin/delegate.sh ...`로 대체 가능(전환 과도기)"

### 권장 대응
- `delegate.sh` 내부에서 `agy` 없으면 `gemini` 자동 fallback 로직 추가
- 또는 `harnessing_state_claude.json`의 `cleminiCLI` 값을 delegate.sh가 읽도록 수정
- setup 스킬에서 `CLEMINI_CLI` 환경변수를 `.bashrc`에 자동 등록하는 절차 추가

---

## [BUG-2] AGENTS.md @import 미전개 (please-work-claude BUG-1과 동일)

### 유형
bug

### 요약
`~/.claude/CLAUDE.md`에 `@/workspace/00/please-work-clemini/rules/AGENTS.md` import 추가했으나 세션에 로드 안 됨.

### 무슨 일이
- please-work-claude BUG-1과 동일한 원인
- AGENTS.md의 라우팅 규칙(Gemini 위임 기준, Never yolo 등)이 AI 컨텍스트에 없음

### 권장 대응
- please-work-claude BUG-1 수정에 연동해 동일하게 처리

---

## [FRICTION-1] clemini에 log_for_test 없음

### 유형
friction

### 요약
clemini 저장소에 피드백 로그 디렉토리가 없어 please-work-claude에 혼합 기록 중.

### 권장 대응
- clemini에도 `log_for_test/` 추가
- 또는 모든 피드백을 please-work-claude에 집중하는 걸 명시적으로 정책화

---

## 반영 (260623)

전수 triage — 세 항목 모두 종결(close).

- **[BUG-1] agy 미설치 fallback** → **기각·대체(설계 결정)**. clemini는 `agy` 전용으로 확정(README: "agy 전용", "gemini 폴백 없음"). 자동 gemini fallback은 도입하지 않음 — 두 CLI의 권한·샌드박스 모델이 달라 폴백이 안전 가정을 흐림. 대신 delegate.sh가 미설치 시 설치 안내(`curl ... antigravity.google/cli/install.sh`)를 출력하므로 피드백의 "설치 안내" 기대는 충족. **종결.**
- **[BUG-2] @import 미전개** → **반영(claude BUG-1 연동)**. import 대신 규칙 **내용 직접 병합(append)**을 기본으로 채택(please-work-claude 260618 반영과 동일). clemini AGENTS.md도 병합 적용 대상. **종결.**
- **[FRICTION-1] clemini에 log_for_test 없음** → **해결**. clemini에 `log_for_test/` + `FEEDBACK_TEMPLATE.md` 생성됨(이 파일이 그 안에 있음). 피드백은 각 프로젝트 자체 `log_for_test/`에 분산 기록하는 것으로 정책 확정. **종결.**
