---
title: agy --print 비대화 모드 — 실제 동작과 함정 (clemini의 존재 이유)
type: reference
date: 260702_2210
tags: [agy, print, headless, safety]
links: [260702_2210_agy-flags-and-subcommands]
---

**출처: 실증** — clemini 운용에서 직접 확인한 동작. 공식 docs(cli-using)에는 print 모드 설명이 **없다**(코호트 조사 260702).

- **동작**: `agy --print "<프롬프트>"` — 헤드리스 단발 실행, 응답을 stdout으로. 타임아웃 기본 5m(`--print-timeout`).
- **함정 1 — 읽기전용이 아니다**: `--print`도 **cwd에 파일을 쓴다**(실증: rule_plan_work.md를 자기 작업로그로 수정). → delegate.sh가 mktemp/`--workspace`(Forge) 격리로 방어.
- **함정 2 — 무효 모델 침묵 폴백**: 잘못된 `--model`을 거부 없이 Flash로 강등(실증). → delegate.sh가 `agy models` 대조로 사전 차단.
- **함정 3 — 아티팩트 우회 출력**: 복잡한 산출물은 stdout이 아니라 `~/.gemini/antigravity-cli/brain/<uuid>/*.md`에 쓰고 포인터만 출력. → delegate.sh `_run_agy`가 경로 파싱해 본문 자동 회수.
- **함정 4 — 편집 하달 불가**: 세밀한 "편집만 자동승인" 모드가 없다. 유일한 자동승인 = yolo(전체) = 금지. 편집은 Claude가 직접.
- **쿼터**: 데스크탑/IDE와 같은 구독 쿼터 공유, 호출당 ~25k 토큰 오버헤드(Ultra 기준 잉여).

이 함정들의 래퍼가 [`bin/delegate.sh`](../bin/delegate.sh)다 — raw `agy --print`를 직접 쓰지 말고 delegate를 쓸 것.

관련: [[260702_2210_agy-flags-and-subcommands]].
