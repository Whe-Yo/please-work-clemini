---
title: agy 플래그·서브커맨드 인벤토리 (v1.0.15 실측)
type: reference
date: 260702_2210
tags: [agy, cli, reference]
links: [260702_2210_agy-print-mode, 260702_2210_agy-sandbox-flag]
---

**출처: 로컬 실측** — `agy --help`, v1.0.15 (260702). 웹 docs(cli-using)에는 이 인벤토리가 없다 — 버전 올라가면 이 노트도 `--help`로 재대조할 것.

## 플래그
| 플래그 | 용도 |
|---|---|
| `--print` / `-p` / `--prompt` | 단발 비대화 실행 후 응답 출력 → [[260702_2210_agy-print-mode]] |
| `--print-timeout` | print 대기 타임아웃(기본 5m) — 긴 조사 하달 시 늘릴 것 |
| `--model` | 세션 모델 지정. **display-name 전체 문자열**("Gemini 3.5 Flash (High)"). 무효명은 침묵 Flash 폴백(실증) → delegate.sh가 `agy models` 대조로 차단 |
| `--prompt-interactive` / `-i` | 초기 프롬프트 실행 후 대화 계속 |
| `--continue` / `-c` | 최근 대화 이어가기 |
| `--conversation` | 대화 ID로 재개 |
| `--project` / `--new-project` | 프로젝트 지정/신규 |
| `--add-dir` | 워크스페이스에 디렉토리 추가(반복 가능) — cwd 밖 읽기 확장 |
| `--sandbox` | 터미널 제한 샌드박스 → [[260702_2210_agy-sandbox-flag]] |
| `--dangerously-skip-permissions` | 전체 자동승인 = **yolo, clemini 절대 금지**(Abominable Intelligence) |
| `--log-file` | 로그 경로 오버라이드 |

## 서브커맨드
`models`(가용 모델 목록 — delegate.sh 검증 게이트가 사용) · `changelog`(릴리스 노트) · `install`(환경 경로·셸 설정) · `plugin`/`plugins`(플러그인 관리) · `update`(CLI 업데이트) · `help`

관련: [[260702_2210_agy-print-mode]] — print 모드의 실제 함정.
