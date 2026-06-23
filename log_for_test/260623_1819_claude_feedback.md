# Feedback — 260623_1819 / claude

> 환경: Claude Desktop "Cowork"에서 please-moon → clemini 배선 점검 중 발견. 대상: please-work-clemini.

---

## [FRICTION-1] 로컬 main에 upstream 미설정 (claude/gemini 클론과 불일치)

### 유형
friction

### 요약
clemini 클론의 `main`이 upstream 추적 브랜치 미설정. `git branch -vv`에 `[origin/main]`이 없다(please-work-claude·please-work-gemini 클론은 있음). 그 결과 `git status`의 ahead/behind 표시, 그리고 인자 없는 `git push`/`git pull --rebase`가 실패한다.

### 무슨 일이
- 하려던 것: feedback 커밋 후 push (feedback 스킬 5절: 거부 시 `git pull --rebase` 후 재시도).
- 일어난 것: `git rev-parse --abbrev-ref main@{upstream}` → `fatal: no upstream configured for branch 'main'`. 단 `refs/remotes/origin/main`(d72ba49)은 존재하고 로컬 main과 동일 커밋이라 **내용은 동기 상태**.
- 기대한 것: 형제 레포처럼 `main`이 `origin/main`을 추적.

### 환경
- 에이전트: claude (Cowork / Claude Desktop)
- OS: macOS host / Linux 샌드박스
- git 2.34.1

### 재현
1. clemini 클론에서 `git branch -vv` → main 줄에 `[origin/main]` 없음.
2. 인자 없는 `git push` 또는 스킬 5절 `git pull --rebase` → upstream 없어 실패.

### 관련 스킬·규칙
- `skills`(claude/gemini 하네스)의 feedback 5절 push 흐름이 upstream 설정을 가정. clemini만 미설정이라 여기서 끊긴다.

### 권장 대응
- 클론/세팅 시 1회 `git branch --set-upstream-to=origin/main main` (또는 최초 push를 `git push -u origin main`).
- clemini 셋업 안내(README/CHANGELOG 또는 setup류 절차)에 upstream 보장 단계 추가.

---

## [FRICTION-2] Cowork 삭제제한 마운트 — 본 클론에서도 index.lock 잔존

### 유형
friction

### 요약
please-work-claude `260623_1819_claude_feedback.md`의 마운트 이슈가 clemini 클론에서도 동일 발생: 점검용 `git status`가 `.git/index.lock`을 남기고 삭제가 막혀 커밋이 선행 차단됨(Cowork 삭제권한 승인 후 해소).

### 권장 대응
- 상세·권장은 please-work-claude 260623_1819 FRICTION-1 참조. clemini는 셸(delegate.sh) 중심이라 직접 영향은 작지만, Cowork에서 clemini 클론에 feedback 커밋 시 동일 절차 필요.
