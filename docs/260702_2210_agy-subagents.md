---
title: agy 비동기 병렬 서브에이전트 — TUI 전용(현재 지식), Maniple과의 관계
type: reference
date: 260702_2210
tags: [agy, subagents, parallel]
links: [260702_2210_agy-docs-sitemap, 260702_2210_agy-print-best-practices]
---

**출처: 웹** — [cli/subagents](https://antigravity.google/docs/cli/subagents) (코호트 정리 260702).

- **무엇**: 고지연 작업(빌드·다중 파일 생성·코드베이스 검색)을 메인 세션 블로킹 없이 백그라운드 병렬 처리하는 특화 에이전트. 메인 에이전트가 위임해 기동.
- **관리(TUI)**: `/agents` 패널 — 실행/완료/종료/에러 체크리스트, 상세 뷰(생각·도구 호출·로그). `Alt+J`(승인 대기 중인 서브에이전트로 텔레포트), `Ctrl+K`(화면 전환 없이 즉시 승인). 비-에이전트 쉘 작업은 `/tasks`.
- **헤드리스(-p) 지원·모델/권한 상속**: 문서에 **명시 없음**.

## Maniple(delegate-fanout)과의 관계
agy 내장 서브에이전트는 **한 agy 세션 안의** 병렬(TUI 관리·승인 필요), Maniple은 **독립 agy 프로세스 N개**(헤드리스·승인 게이트는 격리+Sanction). 현재 지식으론 -p에서 내장 서브에이전트를 쓸 근거가 없으므로 **헤드리스 병렬은 계속 Maniple**. 만약 -p가 내부적으로 서브에이전트를 스스로 띄운다면 하달 1회의 실효 처리량이 이미 병렬일 수 있음 — 실증 여지(백로그).

관련: [[260702_2210_agy-docs-sitemap]].
