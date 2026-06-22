# Changelog

이 프로젝트의 주요 변경을 기록한다. [Keep a Changelog](https://keepachangelog.com/) 형식, [SemVer](https://semver.org/) 지향. 프로토타입이라 0.x.

## [Unreleased]
- (다음 변경을 여기에 누적)

## [0.2.1] - 260622
### Fixed (안전)
- **agy 샌드박스**: `agy --print`(plan)가 "읽기전용"이 아님을 실증(cwd의 `rule_plan_work.md`를 자기 작업로그로 수정). delegate.sh가 `--dir` 미지정 시 **격리된 임시 디렉토리(mktemp -d)에서 agy 실행** → 실제 레포 파일 오염 차단. README의 "안전" 설명도 정정.

## [0.2.0] - 260622
실증 1라운드 반영 — 도구 개선 + 위임 운용 발견.

### Added
- **delegate.sh 아티팩트 회수**: agy `--print`가 복잡 산출물을 `~/.gemini/antigravity-cli/brain/<uuid>/*.md`에 쓰고 stdout엔 포인터만 줄 때, delegate.sh가 그 경로를 파싱해 본문을 자동 회수(cat)해 덧붙인다.

### Notes (실증 발견 — [log_for_test/260622_0753](log_for_test/260622_0753_claude_research-v0.md))
- 패턴 A(컨텍스트 오프로드) 검증, 패턴 C(agy 자체 안티테제 보너스), 패턴 D(Gemini 전제 오류 → Claude 검증 필수).
- **위임 ROI 휴리스틱**: 넓은 조사·교차비판 = 위임 / 좁은 API조회·시각 이터레이션·실재검증 = Claude 직접(호출당 ~25k 오버헤드).

## [0.1.0] - 260618
Claude(머리) + Gemini(손) 오케스트레이션 v0. agy CLI 장착·실증 완료.

### Added
- **역할 분리**: Claude=명세·최종판단, Gemini=조사·1차 안티테제·대량 실행. Gemini를 폭넓게(Ultra 쿼터 여유).
- **`bin/delegate.sh`**: `agy --print` 래퍼. `plan`(읽기·추론) 위임. `auto_edit`는 agy 미지원(유일 자동승인=`--dangerously-skip-permissions`=yolo, 거부).
- **rules/AGENTS.md**: 닫힌 명세 · never yolo · Claude가 최종 검증. 라우팅 표.
- **RPW**(rule_plan_work.md): 머리↔손 계약서.
- **실증**: agy v1.0.9 자동 로그인(Ultra), delegate.sh로 Claude→agy→Gemini end-to-end 동작 확인.

### Notes
- agy 권한 모델은 세밀 편집 모드가 없어 clemini는 plan(조사·분석·1차 반론) 위임에 집중. 편집·최종판단은 Claude.
- [please-work-claude](https://github.com/Whe-Yo/please-work-claude)(Claude 하네스) 위에서 동작하는 위임 층.
