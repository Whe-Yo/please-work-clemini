# Feedback — 260623_1916 / session-poll

> 주간 점검(세션 전사 폴링)에서 자동 수집. 출처 세션: 자산 관리자, 연구자. 대상: please-work-clemini(+ Cowork 런타임 공통). 하네스 결함이 아니라 런타임 한계 기록.

## 유형
friction

## 요약
Cowork 샌드박스가 외부망·네이티브 빌드 불가 → 하네스 기반 라이브 실행/데이터 수집/`git push`는 사용자 맥(호스트)에서만 가능.

## 무슨 일이
- **자산 관리자**: collector 라이브 데이터에서 SEC·Yahoo 403(외부망 차단) → 라이브 수집은 맥에서.
- **연구자**: 샌드박스에서 Metal/MPS 빌드·실행 불가 → 실구동은 M4 직접 또는 computer-use 필요.
- **교차(이 세션)**: `git push`도 샌드박스에 자격증명 없어 불가 — 커밋만 되고 푸시는 맥에서.

## 환경
- 런타임: Claude Desktop Cowork (Linux 샌드박스 셸)
- 공통: 외부망 allowlist 제한 · 네이티브 GPU 빌드 부재 · git 자격증명 부재 · 삭제제한 마운트

## 재현
1. 샌드박스에서 외부 API 호출 / 네이티브(Metal) 빌드 / `git push` 시도 → 각각 차단.

## 관련
- clemini delegate(라이브 데이터)·please-moon 수집층·feedback 스킬 push 흐름. **하네스 규칙 결함 아님 — Cowork 런타임 경계.**

## 반영 (260623)
- **보류 · 문서화 권장**: 코드로 못 막는 런타임 한계라 규칙·스크립트 수정 대상 아님. 권장 = 각 하네스 README/SETUP에 "라이브 실행·외부 데이터·`git push`는 맥(호스트)에서" 한 줄 명시(clemini SETUP.md엔 push 함의 존재). **사용자 결정**: 3개 README 일괄 명시 여부. 결정 전까지 기록만 유지.
