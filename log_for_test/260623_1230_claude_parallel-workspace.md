# clemini 실증 — 병렬 팬아웃 + 워크스페이스 격리 (end-to-end)

**태스크**: please-moon 키 어댑터 3개(TwelveData·Finnhub·FRED)를 병렬 프로토타이핑 → 검토 → 적용.

## 동작 (전부 확인)
- **병렬 팬아웃**: `delegate-fanout.sh --workspace --refine 2` 3 파티션 동시 → 백그라운드(Claude 비차단). Claude는 그동안 검토기준 준비.
- **워크스페이스 격리**: 3개 세션 폴더(타임스탬프+pid+rand) **충돌 0**, agy가 각 폴더에 `*.py` **실제 작성**(파일 격리 확인).
- **검토 게이트**: Claude가 3개 검토 → 적용 → 모듈 import + 무키 graceful + 회귀 없음 검증 → please-moon 반영. **무검토 적용 0.**
- 품질: 3개 다 정확(FRED가 가장 견고 — URL인코딩·'.' 결측·비float 처리).

## 발견 (개선 신호)
- **격리 프로토타입은 모듈 인터페이스를 모른다** → Gemini가 `Tier`/`Fact`를 **로컬 재정의**함. Claude가 적용 시 제거하고 모듈 것으로 교체해야 했음(경미한 통합 마찰).
  - 완화책: 위임 명세에 "정의 재선언 말고 `from please_moon.sources import Tier, Fact` 가정" 명시 / 또는 인터페이스 파일을 워크스페이스에 미리 넣어주기.
- 그 외 병렬+격리+검토 흐름은 마찰 없이 작동. **잉여 Gemini를 병렬로 굴려 산출, Claude는 검토·적용만 — 설계대로.**
