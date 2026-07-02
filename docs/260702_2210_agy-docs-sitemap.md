---
title: agy 공식 docs 지형도 — 어떤 페이지에 뭐가 있나
type: reference
date: 260702_2210
tags: [agy, docs, sitemap]
links: [260702_2210_agy-sandbox-flag, 260702_2210_agy-tui-session-management]
---

**출처: 웹** — 코호트 사이트맵 조사(260702). `cli-using` 한 페이지만 보면 얇다고 오판한다 — CLI 문서는 `docs/cli/` 아래 21페이지로 분산돼 있다.

## clemini에 직결(우선 참조)
- [cli/sandbox](https://antigravity.google/docs/cli/sandbox) — 터미널 샌드박스 상세: Linux `nsjail` / macOS `sandbox-exec` / Windows `AppContainer`, 승인 규칙 → [[260702_2210_agy-sandbox-flag]]
- [cli/best-practices](https://antigravity.google/docs/cli/best-practices) — `-p` 비대화 스크립팅 팁(공식이 다루는 유일한 print 모드 문서), 탐색/계획/실행 워크플로
- [cli/subagents](https://antigravity.google/docs/cli/subagents) — **비동기 병렬 서브에이전트** 프레임워크·`/agents` 패널 (Maniple과 개념 겹침 — 활용 검토 가치)
- [cli/credits](https://antigravity.google/docs/cli/credits) + [plans](https://antigravity.google/docs/plans) — 쿼터·AI 크레딧·overage
- [cli/reference](https://antigravity.google/docs/cli/reference) — 슬래시 명령 전체·settings.json 키
- [cli/conversations](https://antigravity.google/docs/cli/conversations) — 세션 resume·히스토리 → [[260702_2210_agy-tui-session-management]]

## 나머지(필요 시)
overview · getting-started(설치·인증·키링) · using(설정·단축키) · install/permissions(→getting-started 리다이렉트) · features(플러그인·샌드박스·서브에이전트 소개) · gcli-migration(레거시 Gemini CLI 이전) · artifacts(plan/diff 검토) · plugins(skills·rules·MCP 구조) · prompting · settings · statusline · title · troubleshooting(키링·SSH) · tutorial

**교훈**: 웹 문서 조사는 단일 페이지가 아니라 **사이트맵부터** — 코호트에 "페이지 목록+주제 한 줄" 하달이 싸고 정확했다.
