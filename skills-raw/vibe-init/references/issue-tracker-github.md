# 이슈 트래커: GitHub

이 저장소의 이슈와 PRD는 GitHub 이슈로 관리된다. 모든 작업에 `gh` CLI를 사용한다.

## 규칙

- **이슈 생성**: `gh issue create --title "..." --body "..."`. 여러 줄 본문에는 heredoc을 쓴다.
- **이슈 읽기**: `gh issue view <number> --comments`로 댓글을 `jq`로 걸러내고 라벨도 함께 가져온다.
- **이슈 목록**: `gh issue list --state open --json number,title,body,labels,blockedBy,subIssues --jq '[.[] | {number, title, body, labels: [.labels[].name], blockedBy, subIssues}]'`에 알맞은 `--label`과 `--state` 필터를 적용한다. 댓글은 이 목록에서 가져오지 않는다 — `gh issue view <number> --comments`로만 읽는다.
- **이슈 댓글**: `gh issue comment <number> --body "..."`
- **라벨 적용 / 제거**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **닫기**: `gh issue close <number> --comment "..."`

저장소는 `git remote -v`에서 추론한다 — 클론 안에서 `gh`를 실행하면 자동으로 처리된다.

## 트리아지 표면으로서의 풀 리퀘스트

**PR을 요청 표면으로: 아니오.** _(이 저장소가 외부 PR을 기능 요청으로 취급하면 `yes`로 설정. `vibe-plan`의 트리아지 단계가 이 플래그를 읽는다.)_

`yes`로 설정하면 PR도 이슈와 같은 라벨과 상태를 쓰며, `gh pr` 동등 명령을 사용한다:

- **PR 읽기**: `gh pr view <number> --comments`와 diff용 `gh pr diff <number>`.
- **트리아지용 외부 PR 목록**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`에서 `authorAssociation`이 `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, `NONE`인 것만 남긴다(`OWNER`/`MEMBER`/`COLLABORATOR`는 제거).
- **댓글 / 라벨 / 닫기**: `gh pr comment`, `gh pr edit --add-label`/`--remove-label`, `gh pr close`.

GitHub는 이슈와 PR이 번호 공간을 공유하므로 단순 `#42`는 둘 중 하나일 수 있다 — `gh pr view 42`로 확인하고 실패하면 `gh issue view 42`로 돌아간다.

## 스킬이 "이슈 트래커에 게시"라고 말할 때

GitHub 이슈를 생성한다.

## 스킬이 "관련 티켓을 가져오라"고 말할 때

`gh issue view <number> --comments`를 실행한다.

## 경로 탐색 작업

`/vibe-deep-plan`이 사용한다. **맵**은 티켓을 **하위 이슈**로 가진 단일 이슈이다.

- **맵**: `상태:초안`과 `유형:계획` 라벨이 붙은 단일 이슈로 Notes / Decisions-so-far / Fog 본문을 가진다. `gh issue create --label "상태:초안" --label "유형:계획"`.
- **하위 티켓**: 먼저 일반 이슈를 만든 뒤 숫자 database id를 `gh api repos/<owner>/<repo>/issues/<child> --jq .id`로 구한다. `gh api --method POST repos/<owner>/<repo>/issues/<map>/sub_issues -F sub_issue_id=<child-db-id>`로 GitHub native sub-issue 관계를 추가한다. 곧바로 `gh api repos/<owner>/<repo>/issues/<map>/sub_issues --jq 'map(.number)'`를 다시 읽어 `<child>`가 있는지 확인한다. 고수준 도구에 관계 추가 기능이 없는 것은 GitHub에서 하위 이슈가 꺼진 것이 아니다. 이 경우 허용된 `gh api`를 사용한다. 쓰기나 재확인을 할 수 없으면 본문의 `Parent map`, 링크, 작업 목록으로 성공 처리하지 않는다. 만들어졌지만 연결되지 않은 이슈 번호와 실패한 연산을 보고하고 멈춘다. GitHub API가 이 저장소에서 하위 이슈 기능을 지원하지 않는다고 명확히 응답한 경우에만 맵 본문의 작업 목록과 하위 본문 맨 위 `Part of #<map>`으로 대체한다. 라벨: `유형:조사` / `유형:프로토타입` / `유형:인터뷰` / `유형:작업`. 인계되면 티켓을 주도하는 개발자에게 할당한다.
- **차단**: GitHub의 **네이티브 이슈 의존성** — 정규 UI 노출 표현. `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`로 간선을 추가하며, `<blocker-db-id>`는 차단 이슈의 숫자 **데이터베이스 id**(`gh api repos/<owner>/<repo>/issues/<n> --jq .id`, `#number`나 `node_id`가 아님)이다. 열린 차단은 `gh issue list --json blockedBy`의 `blockedBy`(`totalCount` / `nodes`)로 본다. list 출력에서 `issue_dependencies_summary`를 읽지 않는다. `blockedBy`나 네이티브 의존성을 쓸 수 없으면 하위 본문 맨 위에 `Blocked by: #<n>, #<n>` 줄로 되돌아간다. 모든 차단 이슈가 닫히면 티켓이 차단 해제된다.
- **프론티어 질의**: 맵의 열린 하위 목록(`gh issue list --state open --json number,title,labels,blockedBy,assignees,subIssues`, 맵의 하위 이슈 / 작업 목록으로 제한)을 가져와 열린 차단(`blockedBy.totalCount > 0` 또는 비어 있지 않은 `blockedBy.nodes`, 또는 `Blocked by` 줄의 열린 이슈)이나 담당자가 있는 것을 빼고, 맵 순서가 빠른 것이 우선한다.
- **인계**: `gh issue edit <n> --add-assignee @me` — 세션의 첫 기록.
- **조사 인계 해제**: 차팅 중 완전한 결과와 조사 기록 포인터가 저장된 뒤 `gh issue edit <n> --remove-assignee @me`를 실행한다. 조사 이슈는 열어두고 맵 gist를 추가하지 않는다. 저장이 실패하거나 세션이 미완료 작업을 넘기면 담당자를 유지한다.
- **해결**: `gh issue comment <n> --body "<답안>"`, 그리고 `gh issue close <n>`, 그리고 맵의 Decisions-so-far에 컨텍스트 포인터(gist + 링크)를 덧붙인다.


## 조사 기록 저장

- 호출자가 출처 인용을 포함한 완전한 결과를 같은 조사 이슈에 전용 댓글 하나로 올린다. 이후 세션이 불변 이슈 신원으로 찾을 수 있도록 `<!-- vibe-deep-plan research: <map-issue>/<ticket-issue> -->`로 시작한다.
- 댓글이 GitHub 한도를 넘으면 순서 댓글(`Research record 1/N`, `2/N`, ...)이나 저장소 소유 위키, 스니펫, 첨부, 동등한 영속 산출물을 사용하고 이슈 댓글에서 그 기록을 링크한다. 결과를 자르거나 로컬 파일에만 두지 않는다.
- 티켓에 `Research record: <댓글 또는 산출물 URL>`을 기록한다. 호스팅 조사는 `Branch`, `Commit`, `Path` 포인터가 없으며 `research/...` 브랜치를 만들거나 푸시하지 않는다.
- 차팅 중에는 조사 이슈를 열어두고 맵 gist를 추가하지 않는다. 저장 성공 후 `gh issue edit <n> --remove-assignee @me`로 인계를 해제한다. 저장이 실패하면 이슈 인계를 유지한다. 다시 실행하기 전에 기존 댓글과 링크된 산출물을 먼저 확인한다.
