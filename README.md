# Please-Work Clemini

**Claude(머리) + Gemini(손)** 오케스트레이션. Claude가 명세와 최종 판단을 맡고, 조사·1차 반론·대량 실행은 `agy` CLI로 Gemini에 **하달**한다. 사람이 "RPW 만들어 → 제미나이한테 붙여넣어"를 반복하던 수동 중계를 없애는 게 목적이다.

> *For the Omnissiah.*
> 가족: [claude](https://github.com/Whe-Yo/please-work-claude)(Claude 하네스) · [gemini](https://github.com/Whe-Yo/please-work-gemini)(Gemini/Cohort 하네스) · **clemini**(오케스트레이션 층)

## [ 역할 분리 — 머리와 손 ]

- **Claude = Magos(머리)**: 닫힌 명세 작성, 최종 판단, 치명적 검증. 비싼 토큰은 여기에만 쓴다.
- **Gemini = Cohort(손)**: 조사·자료수집·코드탐색·대량 실행 + 1차 반론. 쿼터가 잉여이니 아끼지 않는다 — **사소한 것도 하달하고, 병렬로 돌린다**(의심되면 하달).
- 비싼 모델은 적은 토큰(명세·판단)에, 싼 모델은 많은 토큰(조사·실행·1차 반론)에 — cost-aware sandwich. 라우팅 표는 [`rules/AGENTS.md`](rules/AGENTS.md).
- 단 논리·인과 검토는 Gemini에만 맡기지 않는다. Gemini는 "자신 있는 오답"을 낸다(실증) — 넓이는 Cohort, 깊이는 Magos(또는 `--deep`).

## [ 명명 — Legio Cybernetica ]

역할에 워해머40k 메카니쿠스 호칭을 붙인다. 페르소나가 아니라 이름이다. 규율은 [`rules/AGENTS.md`](rules/AGENTS.md) 그대로.

| 이름 | 역할 |
|---|---|
| **Magos** | Claude(머리) — 명세·최종 판단·봉인 |
| **Cohort** / **Maniple** | Gemini(손) 단일 하달 / 병렬 팬아웃 |
| **Servo-skull** | 감시·기록 드론 — 스케줄 작업이 관찰해 `log_for_test/`에 기록 |
| **Forge** | [`gemini_workspace/`](gemini_workspace/) — 코호트 산출물 격리 단조장 |
| **Sanction** | 검토 게이트 — Magos가 봉인해야 Forge 밖으로 나간다 |
| **Abominable Intelligence 금단** | never-yolo — 승인 게이트 없는 코호트는 폭주, 절대 금지 |

## [ 도구 ]

- [`bin/delegate.sh`](bin/delegate.sh) — 단일 하달. `agy --print`를 격리 디렉토리에서 돌리고 결과를 회수한다.
  - 기본 모델 = **Gemini 3.5 Flash (High)**. `--deep` = Claude Opus 4.6 (Thinking, 깊은 추론 오프로드). `--model`은 `agy models` 대조로 검증(무효명 침묵 폴백 차단).
  - `--refine N`(자기개선 패스) · `--brief`(압축 출력) · `--workspace`(산출물을 Forge에 보존).
- [`bin/delegate-fanout.sh`](bin/delegate-fanout.sh) — 병렬 팬아웃. 파티션된 명세 N개를 동시에 돌리고 파티션별로 모아 반환한다. 각 파티션에 비중복 스코프를 자동 주입하고, 실패 파티션은 배너+stderr로 표면화한다(침묵 실패 없음, 실패 시 exit 1).
- [`bin/muster.sh`](bin/muster.sh) — 통합 셋업. 동반 하네스를 점검하고 gemini 셋업을 Cohort에 하달한다(Forge 산출 → Sanction 후 적용). 상세는 [`SETUP.md`](SETUP.md).

모든 하달에 **에스컬레이션 규칙**이 자동 주입된다 — Cohort는 막히면 추측·강행 대신 `>>> ESCALATE TO MAGOS`를 내고 멈추고, 스크립트가 감지해 채택 금지 배너를 붙인다.

## [ 사용 ]

```sh
# 조사 하달 (한 번에 크게, 권장 기본 --refine 2 --brief)
bin/delegate.sh --refine 2 --brief "이 코드베이스에서 X 기능의 구현 위치·의존성·한계를 파일·라인으로 정리해 보고. 수정 금지."

# 1차 반론 하달 (Claude가 최종 통합)
bin/delegate.sh --brief "아래 설계의 논리 결함·누락·과도한 가정만 비판해 보고. 칭찬 금지: {설계}"

# 병렬 팬아웃 (비중복 파티션 — 백그라운드로 띄우면 Magos는 그동안 다른 일)
bin/delegate-fanout.sh --brief "파티션1 명세" "파티션2 명세" "파티션3 명세"

# 깊은 추론 오프로드
bin/delegate.sh --deep --brief "..."
```

파일 편집은 하달하지 않는다 — agy의 유일한 자동승인은 yolo(전체)뿐이라 금단이다. 편집은 Claude가 직접 한다. clemini는 **agy 전용**이다(`curl -fsSL https://antigravity.google/cli/install.sh | sh`).

> **쿼터**: `agy`는 데스크탑/IDE와 같은 구독 쿼터를 공유한다. 호출당 ~25k 토큰 오버헤드가 있으나 Ultra 기준 잉여 — 병목은 Gemini가 아니라 Magos의 통합이다. 반환은 `--brief`로 압축한다.

## [ 피드백 로그 ]

실사용 마찰은 [`log_for_test/`](log_for_test/)에 남긴다(형식: [`FEEDBACK_TEMPLATE.md`](log_for_test/FEEDBACK_TEMPLATE.md)). 버전 이력은 [CHANGELOG.md](CHANGELOG.md).

---

# Please-Work Clemini (English)

**Claude (head) + Gemini (hands)** orchestration. Claude writes closed specs and makes final judgments; research, first-pass critique, and bulk execution are **commanded down** to Gemini via the `agy` CLI. The goal is to remove the manual relay of "write an RPW → paste it into Gemini" by hand.

> *For the Omnissiah.*
> Family: [claude](https://github.com/Whe-Yo/please-work-claude) (Claude harness) · [gemini](https://github.com/Whe-Yo/please-work-gemini) (Gemini/Cohort harness) · **clemini** (orchestration layer)

## [ Division of Labor ]

- **Claude = Magos (head)**: closed specs, final judgment, critical verification. Expensive tokens go here only.
- **Gemini = Cohort (hands)**: research, collection, codebase exploration, bulk execution, first-pass critique. Quota is surplus — **delegate even small things, and run them in parallel** (when in doubt, delegate).
- Expensive model on few tokens (specs, judgment); cheap model on many (research, execution, first critique) — a cost-aware sandwich. Routing table: [`rules/AGENTS.md`](rules/AGENTS.md).
- Logic and causality review is never left to Gemini alone — it produces "confident wrong answers" (verified). Breadth goes to the Cohort; depth stays with the Magos (or `--deep`).

## [ Naming — Legio Cybernetica ]

Warhammer 40k Mechanicus titles for roles. Names, not personas; the discipline is [`rules/AGENTS.md`](rules/AGENTS.md) as written.

| Name | Role |
|---|---|
| **Magos** | Claude (head) — specs, final judgment, sanction |
| **Cohort** / **Maniple** | Gemini (hands), single delegation / parallel fan-out |
| **Servo-skull** | Watch-and-record drone — scheduled jobs logging to `log_for_test/` |
| **Forge** | [`gemini_workspace/`](gemini_workspace/) — isolated workshop for Cohort output |
| **Sanction** | Review gate — nothing leaves the Forge without the Magos seal |
| **Abominable Intelligence (forbidden)** | never-yolo — an ungated Cohort is a runaway; absolutely forbidden |

## [ Tools ]

- [`bin/delegate.sh`](bin/delegate.sh) — single delegation. Runs `agy --print` in an isolated directory and retrieves the result.
  - Default model = **Gemini 3.5 Flash (High)**. `--deep` = Claude Opus 4.6 (Thinking) for deep-reasoning offload. `--model` is validated against `agy models` (blocks the silent-fallback trap).
  - `--refine N` (self-improvement passes) · `--brief` (compressed output) · `--workspace` (preserve output in the Forge).
- [`bin/delegate-fanout.sh`](bin/delegate-fanout.sh) — parallel fan-out. Runs N partitioned specs concurrently and returns them per partition. Injects a non-overlap scope into each partition; failed partitions surface with a banner plus stderr (no silent failure; exits 1 on any failure).
- [`bin/muster.sh`](bin/muster.sh) — combined setup. Checks companion harnesses and delegates the gemini setup to the Cohort (Forge output → Sanction → apply). Details: [`SETUP.md`](SETUP.md).

Every delegation carries an auto-injected **escalation rule** — when stuck, the Cohort outputs `>>> ESCALATE TO MAGOS` and stops instead of guessing; the scripts detect the marker and attach a do-not-adopt banner.

## [ Usage ]

```sh
# Research (one large closed spec; recommended default --refine 2 --brief)
bin/delegate.sh --refine 2 --brief "Report where feature X is implemented in this codebase — files, lines, dependencies, limits. No edits."

# First-pass critique (Claude integrates and decides)
bin/delegate.sh --brief "Criticize only the logical flaws, omissions, and over-assumptions in this design. No praise: {design}"

# Parallel fan-out (non-overlapping partitions; run in background while the Magos works)
bin/delegate-fanout.sh --brief "partition 1 spec" "partition 2 spec" "partition 3 spec"

# Deep-reasoning offload
bin/delegate.sh --deep --brief "..."
```

File edits are never delegated — agy's only auto-approval is yolo (everything), which is forbidden. Claude edits directly. clemini is **agy-only** (`curl -fsSL https://antigravity.google/cli/install.sh | sh`).

> **Quota**: `agy` shares the same subscription quota as the desktop/IDE. Each call has ~25k tokens of overhead, but on Ultra that is surplus — the bottleneck is not Gemini, it is the Magos integrating results. Compress returns with `--brief`.

## [ Feedback Log ]

Real-use friction goes to [`log_for_test/`](log_for_test/) (format: [`FEEDBACK_TEMPLATE.md`](log_for_test/FEEDBACK_TEMPLATE.md)). Version history: [CHANGELOG.md](CHANGELOG.md).
