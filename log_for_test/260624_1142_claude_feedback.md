# Feedback — 260624_1142 / claude

## 유형
enhancement

## 요약
`agy --model`에 `-high`/`-low` 접미사를 붙이면 빈 응답/폴백으로 무효 — 베이스 모델 ID만 유효(예: `gemini-3.1-pro`). 모델별 사고 강도(High/Low) 선택 방법 명시 필요.

## 무슨 일이
- 하려던 것: `delegate.sh`에서 위임 모델을 사고 강도까지 지정(예: `gemini-3.1-pro-high`).
- 일어난 것: `--model`에 `-high`/`-low` 접미사를 주면 agy가 빈 응답을 내거나 기본 모델로 폴백. 베이스 ID(`gemini-3.1-pro`)만 정상 동작.
- 기대한 것: 접미사로 사고 강도(High/Low)를 선택.
- 로컬 우회(폐기됨): `CLEMINI_MODEL` env로 `--model` override를 `delegate.sh`에 추가했었음. v0.5.1이 `--model` 인자 + 기본 `"Gemini 3.1 Pro (High)"`로 흡수해 로컬 변경은 폐기.
- 관찰: v0.5.1 `delegate.sh:17`은 `MODEL="Gemini 3.1 Pro (High)"`(공백 포함 표기)를 기본으로 둠. 이 표기가 agy에 그대로 전달되는지, 아니면 베이스 ID로 정규화되는지 확인 필요 — 로컬 실증과 정합성 점검 권장.

## 환경
- 에이전트: claude (Claude Code)
- OS: Linux
- 도구: agy CLI, `bin/delegate.sh`

## 재현
1. `agy --model gemini-3.1-pro-high --print "<spec>"` → 빈 응답/폴백
2. `agy --model gemini-3.1-pro --print "<spec>"` → 정상

## 관련 스킬·규칙
- clemini `bin/delegate.sh` (`--model` 처리), please-work-clemini 라우팅 규율
