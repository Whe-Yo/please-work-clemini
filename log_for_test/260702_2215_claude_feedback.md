# 피드백 — fanout 파티션의 "성공 종료 + 무용 본문(SPA 셸)" 실패 모드

- **일시**: 260702_2215
- **에이전트**: claude (Magos, Opus 4.8/Fable 5)
- **대상**: `bin/delegate.sh` / `bin/delegate-fanout.sh` — 웹 페이지 회수 하달

## 현상 (FRICTION)
3파티션 팬아웃 중 파티션 1(https://antigravity.google/docs/cli/sandbox 정리 하달)이 **exit 0 정상 종료했으나 본문이 페이지 요약이 아니라 SPA 앱 셸 raw HTML**(폰트 선언·메타태그)이었다. Cohort의 fetch가 JS 렌더링 전 셸만 받아 그대로 반환 — 에스컬레이션 마커도 없었다("접근 불가"가 아니라 "접근됐는데 내용 없음"이라 Cohort가 실패로 인지 못함). 파티션 2·3은 같은 도메인의 다른 페이지를 정상 요약(라우팅에 따라 렌더 여부가 달랐던 것으로 추정).

- 260702의 "fanout 침묵 실패 표면화"(종료코드 수집)로는 **못 잡는 유형** — 프로세스는 성공, 내용이 실패.

## 제안
1. 웹 정리 하달 명세에 상용구 추가: "받은 본문이 HTML 태그·폰트 선언 등 렌더 전 셸이면 내용 요약을 시도하지 말고 첫 줄에 `>>> ESCALATE TO MAGOS` + '셸만 수신'이라고 보고하라."
2. (선택) delegate.sh가 출력에서 `<!doctype html>`/`<html` 시작을 휴리스틱 감지 → 경고 배너.
3. Magos 규율: 웹 하달 결과는 채택 전 "본문이 실제 내용인가"를 훑을 것(이번엔 육안으로 잡음).

## 재현
`delegate.sh --brief "https://antigravity.google/docs/cli/sandbox 를 읽고 정리..."` — SPA 라우팅 페이지.
