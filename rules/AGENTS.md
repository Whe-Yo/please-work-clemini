# Clemini — 오케스트레이션 규율

> *For the Omnissiah.* — Magos가 Cohort를 지휘하는 Legio Cybernetica 규율.

Magos(Claude·머리)가 Cohort(Gemini·손)에 `agy` CLI로 지령을 **하달**하는 규칙. Gemini(Ultra) 토큰은 잉여, Claude 토큰이 희소. → **사소한 조사·1차 반론·검증도 망설이지 말고 하달**한다. Cohort는 **별개 에이전트라 병렬·백그라운드로** 도니 Magos는 안 기다리고 명세·통합에 집중 → 공짜 병렬. 오버헤드(~25k)는 Gemini 쿼터(잉여) 몫이지 Magos 시간·토큰이 아니다(기본 Flash라 빠르고 쌈).

## 명명 — Legio Cybernetica (이름일 뿐, 페르소나 아님)
역할에 워해머40k 메카니쿠스 호칭을 붙인다. **페르소나가 아니라 이름**이다 — 행동은 아래 규율 그대로.
- **Magos** = Claude(머리): 닫힌 명세 작성·최종 판단·치명적 검증. 코호트에 지령을 내리고 산출을 봉인(Sanction)한다.
- **Cohort** = Gemini(손): 조사·1차 반론·대량 실행·기계작업. 단일 하달(`delegate.sh`).
- **Maniple** = 병렬 팬아웃(`delegate-fanout.sh`): 다수 코호트를 동시에 소집.
- **Forge** = `gemini_workspace/`: 코호트가 산출물을 빚는 격리 단조장.
- **Sanction** = 검토 게이트: Magos가 검증·봉인해야 Forge 밖(본 프로젝트)으로 나간다.
- **Abominable Intelligence 금단** = never-yolo: 결속(승인 게이트) 없이 코호트를 풀면 폭주(금단의 AI)로 타락한다. 절대 금지.
- **Servo-skull** = 자율 감시·기록 드론 = 스케줄 작업(세션 폴링 피드백 점검·일일 업데이트 확인). 다른 세션·repo를 관찰해 `log_for_test/`에 기록·보고.

## 라우팅 — 뭘 누구에게

| 작업 | 담당 | 비고 |
|---|---|---|
| 조사·자료 수집·코드베이스 탐색 | **Gemini** | 큰 컨텍스트·싼 토큰의 강점 |
| 1차·넓은 반론(안티테제, 병렬 swarm) | **Gemini** | 싸게 많이 — 넓이 담당 |
| 대량 실행·기계적 수정·요약 | **Gemini** | 부피는 싼 손이 |
| 오케스트레이션·명세 작성 | **Claude** | 닫힌 명세로 하달 준비 |
| **논리·인과 검토(독립 안티테제)** | **Claude** | claude 하네스 antithesis(독립 인스턴스) — Gemini 반론을 채택만 하지 않고 직접 재검토. 깊이 담당 |
| **최종 판단·채택/기각·치명적 검증** | **Claude** | 제미나이 결과를 통합·재검증 |

핵심: 제미나이를 **1차 일꾼이자 1차 검토자**로 폭넓게 쓰고, Claude는 **명세 + 최종 판단**에 토큰을 집중(효율화 — 중복·장황 배제). **단 논리·인과 검토는 Gemini에만 맡기지 않는다 — 넓이는 Gemini(병렬 반론), 논리 깊이는 Claude가 독립 인스턴스로 직접**(Gemini는 "자신 있는 오답"을 낸다 — 실증). cost-aware sandwich: 싼 손은 넓게, 비싼 머리는 논리·치명에.

### 모델 선택 (delegate.sh가 `agy models`로 검증 — 침묵 폴백 차단)
- **기본 = `Gemini 3.5 Flash (High)`** — 최신 세대. 에이전트·도구·대량 작업에서 구세대 3.1 Pro를 **앞선다**(벤치 실증) + ~3.6배 빠르고 쌈. 조사·대량실행·기계작업 하달의 기본값.
- **깊은 추론·논리 = `--deep`(`Claude Opus 4.6 (Thinking)`)** — agy로 진짜 추론 모델을 헤드리스로 굴려 **호스트 Claude 토큰을 오프로드**. Gemini의 "자신 있는 오답"과 달리 논리에 강함. 논리 깊이 하달이 필요할 때 Gemini 대신 이쪽.
- **어려운 순수(비-에이전트) 추론**은 `--model "Gemini 3.1 Pro (High)"`도 가능(Pro가 순수 추론에선 Flash보다 우위).
- 잘못된 모델명은 delegate.sh가 **거부**한다 — agy `--print`는 무효 모델을 무음으로 Flash 폴백하므로(실증) "Pro로 믿지만 실제 Flash"를 사전 차단.

## 잉여 Gemini 적극 활용 (성능↑ · Claude 토큰↓)
Gemini 토큰이 잉여이므로 더 많이 시켜 품질을 올리고 Claude가 덜 읽고 덜 고치게 한다:
- **`--refine N`** (다중패스 자기개선): Gemini가 직전 결과를 비판·개선 N회 → Claude는 다듬어진 결과만 검토(교정 사이클↓). 함정=환각 루프 → N≤9 캡 + "올바른 부분 보존".
- **`--brief`** (압축 출력): 결정 가능한 형태(결론 먼저·불릿·서론 금지)로 받아 **Claude 읽기 토큰↓**. 함정=과압축 누락 → 필요 시 전체본 재요청.
- **사전 압축**: 대용량(로그·파일·검색)은 Gemini가 먼저 핵심만 추출 → Claude는 노이즈 안 읽음. 함정=치명 단서 절단.
- **앙상블/병렬**: 중요 사안은 독립 하달 여러 번 → 교차 일치 확인(성능). 함정="자신 있는 오답" 합의 → 시점민감·치명은 Claude·결정론 검증.
- 권장 기본: 조사·분석 하달은 `--refine 2 --brief`.

### Gemini 유휴 금지 — 병렬·백그라운드 하달
**원칙: 의심되면 하달(when in doubt, delegate).** 직접 할지 하달할지 애매한 작업은 하달한다 — Cohort는 병렬이라 헛돌아도 Magos 손해 0, 유휴만이 손해다. **결과가 최종 판단에 반영되지 않아도 던지는 게 기본값**(사용자 지시 260702) — 통합 부담 때문에 안 쓰는 게 더 나쁘다. 채택·논리 깊이·최종 판단만 Magos가 직접. **Claude가 작업하는 동안 Gemini는 백그라운드로 조사·프로토·검토를 계속** 돌린다.
- **백그라운드 하달**: `delegate.sh`를 호출자에서 비차단(run_in_background)으로 띄움 → Claude는 다른 일 하고, 완료 시 결과 회수. (delegate.sh는 동기지만 호출을 async로.)
- **병렬 팬아웃**: `bin/delegate-fanout.sh "spec1" "spec2" ...` — N개 **파티션된** 명세를 동시에 여러 Gemini 세션으로. 결과를 파티션별로 모아 반환.
- **파티션 규율**: 각 하달은 **독립·비중복**(같은 연산 두 번 금지 = N개가 같은 일 하면 낭비). Magos가 겹치지 않게 쪼개고, `delegate-fanout.sh`가 각 Cohort에 **파티션 스코프**("너는 파티션 i만 담당, 밖은 금지")를 자동 주입한다. 단 의미적 비중복은 근본적으로 Magos의 명세 절단 책임.
- **반환은 압축**: 항상 `--brief` — Gemini가 요약해 돌려줘야 Claude 통합이 싸다.
- **병목은 Gemini가 아니라 Claude 통합이다**: Gemini(Ultra·클라우드·로컬RAM 0)는 병렬로 펑펑 돌려도 병목 아님. 단 결과를 Claude가 다 읽으면 Claude가 병목 → `--brief` + 파티션으로 **Claude가 흡수 가능한 양**만. (펑펑 쓰되 출력은 압축·분할.)

### 검토 게이트 — Gemini는 본 프로젝트에 직접 쓰지 않는다
agy `--print`는 cwd에 파일을 쓴다(실증). 검토 전 산출물이 실제 프로젝트에 새면 안 된다.
- **파일 산출(프로토타입) 하달 = `--workspace`**: `gemini_workspace/<세션>`(타임스탬프+pid+rand, 병렬에도 유니크)에 **격리·보존**. gitignore됨.
- **순수 조사(텍스트만) = 기본**(휘발 임시 mktemp). `--dir`(실제 디렉토리)는 쓰기 오염 위험이라 비권장(읽기 분석 한정).
- **적용은 Claude가 검토 후 수동 복사.** Gemini 산출물을 무검토로 프로젝트·git에 반영 금지.
- 이름이 `sandbox`가 아니라 `workspace`인 이유: agy가 "아무렇게나 해도 되는 곳"으로 오해하지 않게(안전은 격리+검토가 보장).

### 에스컬레이션 — Cohort가 Magos를 부른다 (헤드리스 콜백)
agy는 단발 헤드리스라 Cohort가 실행 중 Magos에게 실시간으로 못 묻는다. 대신 **반환값으로 호출**한다.
- `delegate.sh`·`delegate-fanout.sh`가 **모든 하달에 에스컬레이션 규칙을 자동 주입**한다 — Cohort는 막히거나·치명적으로 모호하거나·명세가 틀렸/위험하면 **추측·강행 대신** 첫 줄에 `>>> ESCALATE TO MAGOS`를 내고 {막힌 것 / Magos 필요 이유 / 선택지}만 적고 멈춘다.
- delegate.sh가 그 마커를 감지하면 결과 앞에 **채택 금지 배너**를 붙인다(팬아웃은 파티션 헤더에 표시). refine 패스도 에스컬레이션이 뜨면 중단.
- **Magos 처리**: 에스컬레이션은 산출물이 아니다 — 채택 말고 이슈를 해결(재명세 / 판단 / 사용자 문의) 후 재하달.
- WHY: Gemini는 막힌·열린 상황에서 "자신 있는 오답"으로 강행한다(실증). 강행 전에 멈춰 머리를 부르면 폭주·오답 차단 + 토큰 절약(早期 중단).

## Always do
- 하달은 `bin/delegate.sh`로(기본 모델 = **최신 세대 `Gemini 3.5 Flash (High)`**, 깊은 추론은 `--deep`=Opus). 조사·검토는 `--mode plan`(기본). 편집 하달(`auto_edit`)은 agy 미지원.
- **하달은 적극적으로·병렬로.** 사소한 조사·1차 반론·검증도 하달한다 — Cohort는 별개 에이전트라 백그라운드/팬아웃으로 여러 개 동시에 던져도 Magos는 안 기다린다(오버헤드 ~25k는 Gemini 쿼터 잉여 몫). **단 차단(sequential)으로 결과를 기다려야 하는 하달**이면 묶어서 크게 — 그럴 땐 작게 여러 번 ❌. 적극·병렬이라도 지킬 3가지(Cohort 1차 검토로 확증): **① 파티션 독립**(병렬 Cohort 범위 겹치면 중복·모순) **② 반환은 `--brief`, Magos 흡수량만**(진짜 병목은 Gemini가 아니라 Magos의 통합·Sanction) **③ Magos는 기계적 병합 금지**(Cohort 1차 결과를 직접 논리 합성·재검증, 안 그러면 아키텍처 일관성 붕괴).
- 제미나이 1차 결과(조사·반론)는 **Claude가 통합·최종 판단**한다. 채택은 Claude.
- 하달 결과에 `ESCALATE TO MAGOS` 배너가 있으면 **채택 말고** 이슈부터 해결(에스컬레이션 처리) 후 재하달.
- 명세엔 종료조건을 박는다: "X 되면 멈춰". 체크리스트로.
- Claude 토큰은 효율화: 이미 확립된 사실 재도출·장황한 서베이 금지, 추천 1개+근거로.
- **하네스 피드백(능동)**: clemini(`delegate.sh`·`delegate-fanout.sh`·라우팅·규칙)를 실사용하다 버그·마찰·개선점을 만나면 **사용자 지시를 기다리지 말고** `log_for_test/{YYMMDD_HHMM}_{에이전트}_feedback.md`로 즉시 남긴다(형식: `log_for_test/FEEDBACK_TEMPLATE.md`). 비밀(.env·토큰)·프로젝트 작업 내용은 제외. WHY: 잉여 Gemini 하달 구조는 실사용 마찰을 모아야만 다듬어진다 — 다른 세션이 침묵하면 같은 결함이 반복된다.

## Ask first
- 하달 범위가 아키텍처에 닿을 때.
<!-- auto_edit 항목 제거(260702 코호트 감사): delegate.sh가 auto_edit을 무조건 거부(exit 2)하므로 "사전 확인 후 사용" 서술은 코드와 모순 -->

## Never do
- `agy --approval-mode yolo` — 승인 게이트 제거 = 폭주(omega 루프) 부활. Gemini는 열린 작업에서 무조건 미끄러진다(실증).
- "개선/최적화/더 좋게" 같은 **열린 동사로 하달** — 폭주 방아쇠.
- 제미나이의 **1차 검증을 최종으로 채택**하거나 **논리 검토를 Gemini에만 의존** — 독립 1차 반론은 좋지만 논리·인과·치명 검토는 **Claude가 독립 인스턴스로 직접**(claude 하네스 antithesis). 채택만 하지 않는다.
- 비밀(.env·토큰)을 명세나 결과 로그에 포함.

## 동반 하네스 & 통합 셋업 (Muster)
clemini는 단독 하네스가 아니라 **두 동반 하네스 위의 하달 층**이다:
- [please-work-claude](https://github.com/Whe-Yo/please-work-claude) — **Magos 규율**(boost·RPW·antithesis). Claude(머리)가 따른다.
- [please-work-gemini](https://github.com/Whe-Yo/please-work-gemini) — **Cohort 규율**. Gemini(손)가 따른다.

**Muster(통합 셋업)**: "please-work-gemini 설치"는 단독이 아니라 셋을 함께 정렬하는 신호다. `bin/muster.sh`가 동반 하네스를 점검하고, **Cohort(gemini) 규율 셋업은 Cohort(Gemini)에게 하달**한다 — Gemini가 셋업 산출물을 **Forge에만** 만들고 **Magos(Claude)가 Sanction(검토)한 뒤 적용**한다. 무검토 반영 0. (Magos만 있고 Cohort가 없는 반쪽 장착 방지.) 상세는 [`SETUP.md`](../SETUP.md).
- **안전**: agy는 헤드리스 파일편집이 없다(자동승인=yolo뿐 = Abominable Intelligence 금단). 그래서 Cohort 셋업 하달도 **Forge 산출 → Sanction → Magos 적용**만. 시스템 직접 편집 하달은 금지.
- **이원 안티테제**: 안티테제의 "독립 인스턴스" 여러 자리 중 **넓은 반론은 Cohort(Maniple로 병렬)가 싸게 채우고, 논리·인과 깊이는 Magos가 직접**(claude 하네스 antithesis) 수행한다. 호스트 토큰이 빠듯하면 논리 깊이도 `--deep`(agy Opus 4.6 Thinking)로 오프로드 가능 — Gemini 1차 반론과 달리 진짜 추론 모델. 단 최종 통합·채택은 Magos.
