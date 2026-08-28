# 이슈 트래커: 로컬 마크다운

이 저장소의 이슈와 명세(spec; PRD로도 알려져 있다)는 `.agents/plans/` 안의 마크다운 파일로 관리된다.

## 한국어 작성

한국어 명세, 이슈 또는 댓글의 초안을 쓰기 전에 설치된 `vibe-docs` 스킬을 읽고 `필수 적용 순서`를 따른다. `CONTEXT.md`, 관련 ADR, `docs/agents/`에 정의된 도메인 용어와 라벨 문자열은 번역하거나 일반화하거나 중립화하지 않고 원래 표기를 그대로 쓴다.

## 규칙

- 기능마다 디렉터리 하나: `.agents/plans/<feature-slug>/`
- 명세는 `.agents/plans/<feature-slug>/spec.md`
- 구현 이슈는 티켓당 한 파일로 `.agents/plans/<feature-slug>/issues/<NN>-<slug>.md`에 두며, `01`부터 번호 매긴다. `/vibe-plan`이 이 디렉터리를 관리한다.
- Deep-plan 결정 기록은 티켓당 한 파일로 유형별 디렉터리에 둔다:
  - `research/<NN>-<slug>.md` — `유형:조사`(AFK 조사)
  - `interviews/<NN>-<slug>.md` — `유형:인터뷰`(HITL 대화)
  - `prototypes/<NN>-<slug>.md` — `유형:프로토타입`(일회용 산출물)
  - `tasks/<NN>-<slug>.md` — `유형:작업`(수동 선행 작업)
- Deep-plan 기록의 식별자는 `research/03-compare-providers.md`나 `interviews/04-confirm-scope.md` 같은 실제 상대 파일 경로이다. 숫자 접두사는 정렬 키일 뿐이다. 차단 참조는 유형 디렉터리와 `.md` 파일명을 모두 포함해야 하며, `issues/`는 구현 티켓 전용이다.
- 모든 deep-plan 기록은 맨 위 근처에 `Type:` 줄과 `Status:` 줄을 가진다. 트리아지 상태는 `/vibe-plan`이 발행한 구현 티켓에 적용된다.
- Deep-plan 기록은 `Status: open`으로 시작한다. 인계하면 `Status: claimed`로 바뀌고, 차팅 인계를 완료해 해제하면 다시 `Status: open`으로 되돌아간다. 최종 답안만 `Status: resolved`로 바꾼다. 미완료 인계나 저장 실패는 `claimed`를 유지한다.
- 댓글과 대화 기록은 기록 맨 아래 `## Comments` 제목 아래에 덧붙인다. 조사 결과는 구현 이슈가 아닌 조사 기록에 둔다.

## 버전 관리와 완료 갱신

- `.agents/plans/`는 git에서 추적하고, 스크래치 경로(`.agents/worktrees/`, `.agents/prototype/`)는 무시한다. 따라서 티켓 파일은 **브랜치 콘텐츠**이다 — 티켓의 체크리스트 상태는 읽는 브랜치가 말하는 대로이다.
- 구현 티켓의 인수 체크박스는 그것을 구현하는 **기능 브랜치**에서, 구현과 **같은 커밋**에 `[X]`로 바꾼다 — 별도 트래커 커밋이나 타깃 브랜치에서 코드보다 먼저 커밋하지 않는다. 머지는 사람의 결정이며, 머지가 코드와 체크리스트를 함께 가져오거나 둘 다 가져오지 않는다. `상태:` 줄은 바꾸지 않는다.

## 조사 기록 저장

- 로컬 마크다운에서는 조사 티켓과 정규 결과 기록이 같은 `.agents/plans/<effort>/research/<ticket-stem>.md` 파일이다. 출처 인용을 포함한 완전한 결과는 `## Research` 아래에, 최종 결정은 `## Answer` 아래에 둔다.
- 저장소의 무시 정책은 그대로 둔다. 조사 전용 브랜치를 만들거나, 체크아웃하거나, 커밋하거나, 푸시하지 않는다. 기록은 현재 브랜치의 인계 산출물이지 배포 변경이 아니다.
- 조사를 시작하기 전에 기록을 `Status: claimed`로 설정한다. 완전한 결과를 작성한 뒤 차팅 중 `Status: open`으로 되돌린다. 저장이 실패하거나 세션이 미완료 작업을 넘기면 `claimed`를 유지한다. `## Answer` 아래 최종 결정과 함께만 `Status: resolved`로 설정한다. 조사를 다시 실행하기 전에 정규 기록을 먼저 확인한다.

## 스킬이 "이슈 트래커에 게시"라고 말할 때

- `/vibe-plan` 2단계 명세 게시는 `.agents/plans/<feature-slug>/spec.md`를 작성한다. 입력이 통과된 로컬 마크다운 맵이면 그 맵의 기존 `.agents/plans/<effort>/` 디렉터리를 재사용한다.
- `/vibe-plan` 3단계 구현 게시는 `.agents/plans/<feature-slug>/issues/<NN>-<slug>.md`를 작성한다. 통과된 맵이나 `.agents/plans/<effort>/spec.md`의 명세면 같은 `<effort>/issues/` 디렉터리를 쓰고, 다른 로컬 명세 경로는 설정된 `.agents/plans/<feature-slug>/issues/` 루트를 쓴다.
- `/vibe-deep-plan`은 결정 기록을 해당 `research/`, `interviews/`, `prototypes/`, `tasks/` 디렉터리 아래에 게시한다.

## 스킬이 "관련 티켓을 가져오라"고 말할 때

주어진 로컬 계획 산출물을 있는 그대로 읽는다: `map.md`, `spec.md`, deep-plan 결정 기록, 구현 이슈. 다른 기능 루트로 대체하지 않는다. 사용자가 보통 경로를 직접 넘긴다.

## 경로 탐색 작업

`/vibe-deep-plan`이 사용한다. 맵은 티켓당 결정 기록이 하나인 파일이다.

- **맵**: `.agents/plans/<effort>/map.md` — Notes / Decisions-so-far / Fog 본문.
- **조사 기록**: `.agents/plans/<effort>/research/NN-<slug>.md`에 `Type: 조사`와 `Status:` 줄.
- **인터뷰 기록**: `.agents/plans/<effort>/interviews/NN-<slug>.md`에 `Type: 인터뷰`와 `Status:` 줄.
- **프로토타입 기록**: `.agents/plans/<effort>/prototypes/NN-<slug>.md`에 `Type: 프로토타입`, `Status:`, 산출물이 있으면 `.agents/prototype/<name>/` 포인터.
- **작업 기록**: `.agents/plans/<effort>/tasks/NN-<slug>.md`에 `Type: 작업`과 `Status:` 줄.
- **차단**: `Blocked by: research/03-compare-providers.md, interviews/04-confirm-scope.md`. 나열된 각 기록이 해결되면 차단 해제된다.
- **프론티어**: `research/`, `interviews/`, `prototypes/`, `tasks/`의 합집합에서 `Status: open`이고 열린 차단이 없는 기록을 찾아 숫자 접두사, 그리고 정규 상대 경로 순으로 정렬한다.
- **인계**: 작업 전에 `Status: claimed`로 설정하고 저장한다. 로컬 마크다운에는 `Assignee:` 필드가 없다. 호스팅 트래커 담당자 메타데이터를 직렬화하지 않는다.
- **해결**: `## Answer` 제목 아래 답안을 덧붙이고, `Status: resolved`로 설정하고, 맵의 `map.md` Decisions-so-far에 링크된 기록 제목과 한 줄 요지만 덧붙인다.
