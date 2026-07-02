---
title: agy --sandbox — 존재하나 제한 내용 미문서화
type: reference
date: 260702_2210
tags: [agy, sandbox, safety, backlog]
links: [260702_2210_agy-print-mode]
---

**출처: 실측 + 웹.** `--help`(v1.0.15): "Run in a sandbox with terminal restrictions enabled". cli-using 페이지엔 오버라이드 언급뿐이나, **상세 문서는 [cli/sandbox](https://antigravity.google/docs/cli/sandbox)에 별도로 존재**(코호트 사이트맵 조사 260702) — OS별 격리(Linux `nsjail` / macOS `sandbox-exec` / Windows `AppContainer`)·승인 팝업 상호작용을 다룬다. 상세 정리는 [[260702_2210_agy-docs-sitemap]] 경유 후속 노트로.

**clemini 함의(백로그)**: 현재 delegate.sh는 `--print`의 cwd 쓰기(실증)를 mktemp/Forge 격리로 방어한다. `--sandbox`가 파일쓰기까지 막아준다면 이중 방어가 가능 — 단 **제한 범위를 실증하기 전엔 격리를 대체하지 말 것**(터미널 제한만일 수 있음). 실증 방법: 샌드박스 모드에서 "cwd에 test.md를 써라" 하달 → 쓰기 여부 확인.

관련: [[260702_2210_agy-print-mode]] — 현행 격리 방어.
