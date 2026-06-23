# gemini_workspace — Gemini 검토대기 산출물

Gemini(agy)가 **프로토타입·파일을 만드는** 위임은 본 프로젝트가 아니라 **여기서** 돈다.
검토 전에는 어떤 산출물도 실제 프로젝트(please-moon 등)에 적용되지 않는다.

## 흐름 (검토 게이트)
1. `delegate.sh --workspace ...` → `gemini_workspace/<YYMMDD_HHMMSS_pid_rand>/`에서 Gemini 실행. 경로를 stderr로 알림.
2. 산출물은 세션 폴더에 **격리·보존**(병렬 다중 세션도 폴더 충돌 없음 — 타임스탬프+pid+rand).
3. **Claude가 검토** → 채택할 부분만 실제 프로젝트로 **수동 복사**(적용). 나머지는 폐기.

## 규칙
- 세션 폴더는 **gitignore**(이 README만 추적). 검토 안 된 Gemini 산출물을 커밋하지 않는다.
- 이름이 "sandbox"가 아니라 "workspace"인 이유: agy가 폴더명을 "아무렇게나 해도 되는 곳"으로 오해하지 않게. **안전은 이름이 아니라 격리+검토 게이트가 보장.**
- 순수 조사(텍스트 출력만)는 `--workspace` 없이 휘발 임시(mktemp)로 충분. 파일 산출(프로토타입)일 때만 `--workspace`.
- 정리: 검토 끝난 세션 폴더는 삭제. (이 디렉토리가 무한정 쌓이지 않게.)
