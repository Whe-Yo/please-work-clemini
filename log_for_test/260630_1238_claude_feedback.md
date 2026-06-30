# Feedback — 260630_1238 / claude

## 유형
bug

## 요약
delegate.sh가 agy 인증 만료/timeout 시에도 exit 0을 반환 — 실패를 정상으로 위장해 빈 결과 무검토 채택 위험.

## 무슨 일이
- 하려던 것: delegate.sh로 Gemini에 사소한 산수 위임(round-trip 작동 확인).
- 일어난 것: agy OAuth 토큰 만료 상태라 "Authentication required ... authentication timed out." 출력 후 **delegate.sh가 exit 0**으로 종료. 산출물(결과 텍스트)은 비어 있었음.
- 기대한 것: 인증 실패/빈 응답이면 비제로 종료(또는 ESCALATE 배너)로 호출자가 실패를 인지해야 함.

## 영향
- 호출자(Magos)가 exit 0 + 빈 출력을 정상 완료로 오인 → 빈/부분 결과를 무검토 채택할 위험. 특히 백그라운드·팬아웃 위임에서 침묵 실패가 묻힌다.

## 제안
- agy 출력에서 `Authentication required` / `authentication timed out` / 빈 응답을 감지하면 비제로 종료.
- 또는 결과 앞에 `>>> ESCALATE TO MAGOS` 배너를 붙여 채택 금지 처리(기존 에스컬레이션 경로 재사용).

## 환경
- 에이전트: claude (host) / OS: Linux / 도구: agy 1.0.13, delegate.sh
- 재인증(agy 대화형 로그인)으로 토큰 갱신 후 동일 위임은 정상(17×23=391) — 즉 인증 만료 구간에서만 재현.

## 재현
1. agy OAuth 토큰이 만료된 상태에서
2. `bash bin/delegate.sh --brief "..."` 실행
3. 인증 timeout 메시지 출력 + `echo exit=$?` → 0 확인

## 관련 스킬·규칙
- clemini: delegate.sh 에스컬레이션/종료코드 처리, "1차 검증 무검토 채택 금지" 규칙
