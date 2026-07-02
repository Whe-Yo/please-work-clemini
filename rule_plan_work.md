# RPW — please-work-clemini

## Rule

### Always do
- Claude는 머리(닫힌 명세·검증), Gemini는 손(게이트 안 실행)
- 위임은 `bin/delegate.sh`, 검증은 Claude가 결정론적으로
- 명세에 종료조건 명시

### Ask first
- 하달 범위가 아키텍처에 닿을 때 (auto_edit 항목은 260702 제거 — delegate.sh가 무조건 거부하므로 모순)

### Never do
- `agy yolo` (폭주 게이트 제거)
- 열린 동사로 위임
- 검증 없이 채택

---

## Plan

목표: **극한 효율 협업 구조 연구** (Claude Max 5x — 토큰 병목 해소 후)

연구 설계 v0: [log_for_test/260622_0753_claude_research-v0.md](log_for_test/260622_0753_claude_research-v0.md)
- [x] v0 (장착·실증): agy 전용 delegate.sh, plan 위임 동작 확인, agy 설치 요청(폴백 제거)
- [x] 연구 틀 확정: 논제(Gemini=넓은 깔때기/Claude=날카로운 끝), 핵심 패턴 5(오프로드·병렬팬아웃·교차비판·적용전검증·명세압축), 지표 4, 비위임 4 — Gemini 1차 분석 위임 후 Claude 종합
- [x] **1차 실험**: 패턴 A(컨텍스트 오프로드) 검증됨 — 별도 빌드 태스크를 벤치마크로 오프로드 작동·재작업 0 확인. 발견은 [research-v0 §5](log_for_test/260622_0753_claude_research-v0.md).
- [x] delegate.sh 아티팩트 회수 구현 (`delegate.sh` 인라인 cat — brain/<uuid>/*.md 회수)
- [ ] 위임 ROI 휴리스틱(넓은 조사=위임/좁은 조회=직접)을 rules에 codify
- [ ] 패턴별 실험 (안티테제 규율)
- [ ] 검증 헬퍼(제미나이 결과 자동 대조)

---

## Work

**장착·실증 완료.** agy **v2.0**(260626 확인) 로그인, `bin/delegate.sh --mode plan "..."`이 agy `--print`로 호출해 실제 응답 수신. agy 권한 모델은 세밀 모드 없이 `--dangerously-skip-permissions`(=yolo, 금지)뿐이라, clemini는 **plan(읽기·조사·1차 안티테제) 위임에 집중**하고 파일 편집은 Claude/IDE가 맡는다.

**260626 모델 정비**: 기본 위임 모델을 **최신 세대 `Gemini 3.5 Flash (High)`**로 통일(에이전트·대량작업 우위·~3.6배 빠르고 쌈 — 벤치 실증). 깊은 추론·논리는 `--deep`(`Claude Opus 4.6 (Thinking)`)로 헤드리스 위임해 호스트 토큰 오프로드. delegate.sh에 **모델 검증 게이트** 추가 — agy `--print`가 무효 모델명을 거부 없이 Flash로 '침묵 폴백'하는 문제 차단(안티테제 발견).

이전: clemini v0. 사용자 방향 반영: **Gemini를 아끼지 말고 조사·1차 논리검증(안티테제)·대량 실행에 폭넓게**, Claude는 명세+최종판단에 토큰 집중(효율화). 단 agy 호출당 ~23–25k 오버헤드(Pro 쿼터 빠른 소진) 때문에 "호출은 묶어 크게" 규칙 추가. agy=데스크탑/IDE와 같은 구독 쿼터 공유(별도 크레딧 아님). 메커니즘은 `gemini -p`로 동작 확인됨. **실증은 agy 설치+인증 후** — 그게 유일한 차단 요인.
