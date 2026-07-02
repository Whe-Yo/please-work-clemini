# Changelog

이 프로젝트의 주요 변경을 기록한다. [Keep a Changelog](https://keepachangelog.com/) 형식, [SemVer](https://semver.org/) 지향. 프로토타입이라 0.x.

## [Unreleased]

## [0.6.1] - 260702
### Added
- **`docs/` 개시 — agy CLI 지식 제텔카스텐**: INDEX(MOC) + 원자 노트 4건(플래그·서브커맨드 인벤토리 실측 v1.0.15 / `--print` 함정 4종 실증 / TUI 세션 관리 웹 / `--sandbox` 미문서화·실증 백로그). 출처 우선순위 명문화: 실측 > 실증 > 웹(공식 cli-using 페이지는 얇음 — 코호트 조사로 확인).
### Changed
- **하달 기본값 명문화(사용자 지시 260702)**: `rules/AGENTS.md`의 "의심되면 하달"에 **"결과가 최종 판단에 반영되지 않아도 던지는 게 기본값"** 추가 — 통합 부담 때문에 코호트를 안 쓰는 게 더 나쁘다. 채택·논리 깊이·최종 판단만 Magos 직접. (동반: claude 하네스가 조사·편집 임계치서 코호트 하달을 최우선 자문으로 환기.)

## [0.6.0] - 260702
Legio Cybernetica 명명·에스컬레이션·모델 게이트 + 260702 안티테제 결함 수정.

### Fixed
- **fanout 침묵 실패 표면화(260702 안티테제)**: 일괄 `wait`가 자식 종료코드를 삼켜 모델 거부·agy 실패 파티션이 "정상 헤더+빈 본문"으로 통과하던 결함 → 파티션별 종료코드 수집, 실패 파티션은 **실패 배너+stderr 전체+채택 금지**, 하나라도 실패면 exit 1(호출자 Magos가 놓치지 못하게). 실패(무효 모델 2파티션)·성공(마이크로 하달 2파티션) 경로 실증.
- **에스컬레이션 마커 행 시작 앵커(260702)**: 본문 중 인용("...ESCALATE TO MAGOS...")만으로 refine 중단·배너가 뜨던 오탐 → `^>>> ESCALATE TO MAGOS`(행 시작)만 인정. delegate.sh·fanout 일괄.
- **로컬 main upstream 설정**(피드백 260623_1819 FRICTION-1): `git branch --set-upstream-to=origin/main main` — 형제 레포처럼 origin/main 추적, push/`pull --rebase` 정상화.
- **삭제제한 마운트 index.lock wedge 해소**(피드백 260623_1819 FRICTION-2): 정체 락 제거.

### Added
- **능동 피드백 규칙**: `rules/AGENTS.md` Always do에 "clemini 실사용 중 버그·마찰·개선점 발견 시 사용자 지시 없이도 `log_for_test/..._feedback.md`로 즉시 기록" 능동 지침 추가(형식: FEEDBACK_TEMPLATE.md).
- **Legio Cybernetica 명명**(역할 이름, 페르소나 아님): Magos(Claude)·Cohort/Maniple(Gemini 단일/병렬)·Servo-skull(스케줄 감시·기록 드론)·Forge(workspace)·Sanction(검토 게이트)·Abominable Intelligence 금단(never-yolo), 우산명 Legio Cybernetica. README·AGENTS 용어집 — 일하는 이름 8개.
- **동반 하네스 참조 + 통합 셋업(Muster)**: README·AGENTS에 please-work-claude(Magos 규율)·please-work-gemini(Cohort 규율) 동반 명시. `bin/muster.sh` + `SETUP.md` 추가 — "gemini 설치"는 셋을 함께 정렬, gemini 셋업은 Cohort(Gemini)에 위임(Forge 산출) → Magos Sanction 후 적용(무검토 반영 0).
- **이원 안티테제 명문화**: 논리·인과 검토를 Gemini에만 두지 않고 Claude(독립 인스턴스)가 직접 수행하도록 라우팅·독트린 보강. Gemini=넓은 1차 반론(병렬 swarm) / Claude=논리 깊이·치명 검증. WHY: Gemini는 "자신 있는 오답"을 낸다(실증) — 논리는 머리가 직접.
- **명명 최적화(과명명 트림)**: Servitor·Doctrina Imperative·Datavault는 평범한 용어로 환원(Cohort에 흡수 / 명세·RPW / log_for_test). 행위자·안전 파이프라인 이름만 유지 → 최종 8개.
- **에스컬레이션 (Cohort→Magos 호출)**: `delegate.sh`·`delegate-fanout.sh`가 모든 위임에 "막히면 `>>> ESCALATE TO MAGOS` 내고 멈춰라"를 자동 주입 + 반환 마커 감지해 채택 금지 배너(팬아웃은 파티션 헤더, refine도 중단). 헤드리스라 실시간 콜백은 없지만 반환값으로 호출 — 강행("자신 있는 오답") 차단.
### Changed
- **README 전면 재작성(260702)**: 스타일 통일 — `[ 제목 ]` 섹션, 담백한 서술, 한국어 본문 + 영어 미러. 내용 최신화 — 기본 모델 3.5 Flash(구 "3.1 Pro" 서술 스테일 정정), fanout·escalation·`--deep`·하달 용어 반영.
- **기본 위임 모델 = 최신 세대 `Gemini 3.5 Flash (High)`** (구 `3.1 Pro`에서 변경): 에이전트·도구·대량작업에서 3.1 Pro를 앞서고(벤치) ~3.6배 빠르고 쌈. `delegate.sh:17`. 어려운 순수 추론은 `--model "Gemini 3.1 Pro (High)"`로.
- **agy Opus 활용 — `--deep`**: `Claude Opus 4.6 (Thinking)` 위임(깊은 추론·논리를 헤드리스 Opus로 → 호스트 Claude 토큰 오프로드). `delegate-fanout.sh`도 패스스루.
- **모델 검증 게이트**(안티테제 발견): agy `--print`가 잘못된 `--model`을 거부 없이 Flash로 '침묵 폴백'함 → `delegate.sh`가 `agy models` 대조로 무효 모델명 사전 거부. "Pro로 믿지만 실제 Flash" 침묵 강등 차단.
### Notes
- claude에 잘못 보관됐던 clemini 피드백(260618_1605)을 이리로 이전 + 항목별 triage·반영표시(close).

## [0.5.1] - 260623
### Added
- **`delegate-fanout.sh`에 `--workspace` 전달** + 각 파티션의 워크스페이스 경로 표시 → 병렬 팬아웃 + 격리 워크스페이스 **동시 사용**(end-to-end 실증: please-moon 어댑터 3개 병렬 프로토타입→검토→적용).

## [0.5.0] - 260623
검토 게이트 — Gemini 산출물 격리.

### Added
- **`--workspace`**: 파일 산출(프로토타입) 위임을 `gemini_workspace/<YYMMDD_HHMMSS_pid_rand>`에 **격리·보존**(병렬에도 유니크). 검토 전 본 프로젝트 미적용. gitignore(README만 추적).
- `gemini_workspace/README.md`: 검토 게이트 흐름·규칙. 이름은 `sandbox` 대신 `workspace`(agy 오해 방지).
### Notes
- 기본은 휘발 임시(순수 조사). `--dir`(실제 디렉토리)는 쓰기 오염 위험으로 비권장.

## [0.4.0] - 260622
Gemini 유휴 금지 — 병렬·백그라운드 위임.

### Added
- **`bin/delegate-fanout.sh`**: N개 파티션된 명세를 **동시에 여러 Gemini 세션**으로 위임(병렬 팬아웃), 결과를 파티션별로 모아 반환. 호출자에서 백그라운드로 띄우면 Claude 작업 중 Gemini 병렬 가동.
- rules 독트린: "Gemini 유휴 금지 — Claude 작업 중 백그라운드 조사·검토 병렬. 파티션은 독립·비중복, 반환은 `--brief`. **병목은 Gemini가 아니라 Claude 통합** → 압축·분할로 흡수 가능량만."

## [0.3.0] - 260622
잉여 Gemini 적극 활용 — 성능↑ · Claude 토큰↓ (연구·실증 반영).

### Added
- **`--refine N`** (1~9): 다중패스 자기개선 — Gemini가 직전 결과를 비판·개선 N회. Claude는 다듬어진 결과만 검토(교정 사이클↓). 환각루프 방지로 N 캡 + "올바른 부분 보존".
- **`--brief`**: 결정가능 압축출력(결론 먼저·불릿·서론 금지) → Claude 읽기 토큰↓.
- 아티팩트 인라인 회수 헬퍼(`_run_agy`) — refine 패스가 실제 본문 위에서 동작.
### Changed
- rules/AGENTS.md 독트린: "Gemini 잉여 → 적극 위임(refine·brief·사전압축·앙상블), Claude는 명세·최종판단·시점민감 검증". 스테일 플래그(`-p`/`--approval-mode`) 교정.
- 권장 기본: 조사·분석 위임 `--refine 2 --brief`.

## [0.2.2] - 260622
### Changed
- **모델 기본값 = 최신 Gemini Pro**: delegate.sh가 `agy --model "Gemini 3.1 Pro (High)"`로 위임(사용자 지시 — 항상 최신 Pro). `--model`로 override. (`agy models`로 현재 가용 모델 확인.)

## [0.2.1] - 260622
### Fixed (안전)
- **agy 샌드박스**: `agy --print`(plan)가 "읽기전용"이 아님을 실증(cwd의 `rule_plan_work.md`를 자기 작업로그로 수정). delegate.sh가 `--dir` 미지정 시 **격리된 임시 디렉토리(mktemp -d)에서 agy 실행** → 실제 레포 파일 오염 차단. README의 "안전" 설명도 정정.

## [0.2.0] - 260622
실증 1라운드 반영 — 도구 개선 + 위임 운용 발견.

### Added
- **delegate.sh 아티팩트 회수**: agy `--print`가 복잡 산출물을 `~/.gemini/antigravity-cli/brain/<uuid>/*.md`에 쓰고 stdout엔 포인터만 줄 때, delegate.sh가 그 경로를 파싱해 본문을 자동 회수(cat)해 덧붙인다.

### Notes (실증 발견 — [log_for_test/260622_0753](log_for_test/260622_0753_claude_research-v0.md))
- 패턴 A(컨텍스트 오프로드) 검증, 패턴 C(agy 자체 안티테제 보너스), 패턴 D(Gemini 전제 오류 → Claude 검증 필수).
- **위임 ROI 휴리스틱**: 넓은 조사·교차비판 = 위임 / 좁은 API조회·시각 이터레이션·실재검증 = Claude 직접(호출당 ~25k 오버헤드).

## [0.1.0] - 260618
Claude(머리) + Gemini(손) 오케스트레이션 v0. agy CLI 장착·실증 완료.

### Added
- **역할 분리**: Claude=명세·최종판단, Gemini=조사·1차 안티테제·대량 실행. Gemini를 폭넓게(Ultra 쿼터 여유).
- **`bin/delegate.sh`**: `agy --print` 래퍼. `plan`(읽기·추론) 위임. `auto_edit`는 agy 미지원(유일 자동승인=`--dangerously-skip-permissions`=yolo, 거부).
- **rules/AGENTS.md**: 닫힌 명세 · never yolo · Claude가 최종 검증. 라우팅 표.
- **RPW**(rule_plan_work.md): 머리↔손 계약서.
- **실증**: agy v1.0.9 자동 로그인(Ultra), delegate.sh로 Claude→agy→Gemini end-to-end 동작 확인.

### Notes
- agy 권한 모델은 세밀 편집 모드가 없어 clemini는 plan(조사·분석·1차 반론) 위임에 집중. 편집·최종판단은 Claude.
- [please-work-claude](https://github.com/Whe-Yo/please-work-claude)(Claude 하네스) 위에서 동작하는 위임 층.
