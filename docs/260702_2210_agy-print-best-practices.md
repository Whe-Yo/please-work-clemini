---
title: agy -p 공식 베스트프랙티스 — 자동화 패턴과 주의점
type: reference
date: 260702_2210
tags: [agy, print, automation, best-practices]
links: [260702_2210_agy-print-mode, 260702_2210_agy-docs-sitemap]
---

**출처: 웹** — [cli/best-practices](https://antigravity.google/docs/cli/best-practices) (코호트 정리 260702). ⚠️ 코호트 응답 중 로컬 실측과 어긋나는 항목은 미검증 표기.

## 공식 권장 -p 패턴
- **단발 쉘 유틸 연동**: git hook에서 diff 분석→커밋 메시지 초안 등, 파이프라인 배치 실행(CI/CD).
- **`--print-timeout`**: 복잡한 추론 시 무한 대기 방지(기본 5m — [[260702_2210_agy-flags-and-subcommands]]).
- **`settings.json` `toolPermission` 사전 튜닝**: 비대화 실행 중 도구 자동실행 범위 제어.

## ⚠️ 미검증(코호트 주장, 로컬 대조 실패)
- **`--cwd <path>`**: 코호트가 예시로 제시했으나 **v1.0.15 `--help`에 없음** — 환각 또는 버전 차이 의심. 실행 경로 지정은 실측 확인된 `--add-dir` / cd 후 실행으로.
- **`ANTIGRAVITY_API_KEY` 환경변수**(헤드리스 인증): 문서 근거 재확인 필요. 현행 clemini는 Google 로그인 세션 재사용으로 동작(실증).

## 기타 섹션(한 줄씩)
검증 루프(테스트 전후 실행) · 탐색→계획→실행 순서 · `@` 파일참조·이미지 붙여넣기 · `GEMINI.md`/`AGENTS.md` 룰 · `/rewind`·`/fork` 세션 관리 · **병렬 서브에이전트 팬아웃**([[260702_2210_agy-subagents]]).

관련: [[260702_2210_agy-print-mode]] — clemini가 실증한 함정 4종(문서에 없는 것들).
