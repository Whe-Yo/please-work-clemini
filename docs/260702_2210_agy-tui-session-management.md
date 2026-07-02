---
title: agy TUI 대화 관리 — /fork·/clear·/resume·자동 재개
type: reference
date: 260702_2210
tags: [agy, tui, session]
links: [260702_2210_agy-flags-and-subcommands]
---

**출처: 웹** — [cli-using](https://antigravity.google/docs/cli-using) (코호트 정리 260702). 이 페이지는 Settings·Quick Tips·Keybindings 중심으로 얇다.

- **`/fork`**: 별도 워크스페이스를 띄워 이전 시점부터 대화를 분기.
- **`/clear`**: 프롬프트 비우고 새 대화 세션.
- **`/resume`**: 이전 대화 로그 목록에서 골라 재개.
- **자동 저장 재개**: CLI 종료 시 그 세션을 재개하는 명령을 터미널에 자동 출력.
- CLI 시작 플래그 대응물: `--continue`(-c)·`--conversation`(ID 재개) — 웹 문서엔 미기재, [[260702_2210_agy-flags-and-subcommands]] 실측 참조.

clemini 관점: delegate.sh는 **단발(stateless)** 하달이라 TUI 세션 기능을 쓰지 않는다. 연속 맥락이 필요한 하달은 `--continue`/`--conversation` 활용을 검토할 것(미실증 — 백로그).
