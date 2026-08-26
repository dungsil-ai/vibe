# 이슈 트래커: GitLab

이 저장소의 이슈와 PRD는 GitLab 이슈로 관리된다. 모든 작업에 [`glab`](https://gitlab.com/gitlab-org/cli) CLI를 사용한다.

## 규칙

- **이슈 생성**: `glab issue create --title "..." --description "..."`. 여러 줄 설명에는 heredoc을 쓴다. `--description -`을 주면 편집기가 열린다.
- **이슈 읽기**: `glab issue view <number> --comments`. 기계 판독 출력에는 `-F json`을 쓴다.
- **이슈 목록**: `glab issue list -F json`에 알맞은 `--label` 필터를 적용한다.
- **이슈 댓글**: `glab issue note <number> --message "..."`. GitLab은 댓글을 "notes"라 부른다.
- **라벨 적용 / 제거**: `glab issue update <number> --label "..."` / `--unlabel "..."`. 여러 라벨은 쉼표로 구분하거나 플래그를 반복한다.
- **닫기**: `glab issue close <number>`. `glab issue close`는 닫는 댓글을 받지 않으므로 먼저 `glab issue note <number> --message "..."`로 설명을 올리고 닫는다.
- **머지 리퀘스트**: GitLab은 PR을 "merge requests"라 부른다. `glab mr create`, `glab mr view`, `glab mr note` 등을 사용한다 — `gh pr ...`와 같은 형태에서 `pr` 대신 `mr`, `comment`/`--body` 대신 `note`/`--message`를 쓴다.

저장소는 `git remote -v`에서 추론한다 — 클론 안에서 `glab`을 실행하면 자동으로 처리된다.

## 트리아지 표면으로서의 머지 리퀘스트

**MR을 요청 표면으로: 아니오.** _(이 저장소가 외부 머지 리퀘스트를 기능 요청으로 취급하면 `yes`로 설정. `vibe-plan`의 트리아지 단계가 이 플래그를 읽는다.)_

`yes`로 설정하면 MR도 이슈와 같은 라벨과 상태를 쓰며, `glab mr` 동등 명령을 사용한다:

- **MR 읽기**: `glab mr view <number> --comments`와 diff용 `glab mr diff <number>`.
- **트리아지용 외부 MR 목록**: `glab mr list -F json`에서 작성자가 프로젝트 멤버/소유자가 아닌 MR만 남긴다(유지보수자의 진행 중 작업이 아닌 기여자의 MR).
- **댓글 / 라벨 / 닫기**: `glab mr note`, `glab mr update --label`/`--unlabel`, `glab mr close`.

GitHub와 달리 GitLab은 이슈와 MR을 따로 번호 매기므로 `#42`는 유지보수자가 어느 표면을 뜻하는지 알면 모호하지 않다.

## 스킬이 "이슈 트래커에 게시"라고 말할 때

GitLab 이슈를 생성한다.

## 스킬이 "관련 티켓을 가져오라"고 말할 때

`glab issue view <number> --comments`를 실행한다.

## 경로 탐색 작업

`/vibe-deep-plan`이 사용한다. **맵**은 티켓을 **하위 이슈**로 가진 단일 이슈이다.

- **맵**: `상태:초안` 라벨이 붙은 단일 이슈로 Notes / Decisions-so-far / Fog 본문을 가진다. `glab issue create --label "상태:초안"`. (네이티브 에픽이 있는 GitLab 티어에서는 에픽이 맵을 대신할 수 있다. 라벨이 붙은 이슈는 어디서든 작동한다.)
- **하위 티켓**: 설명 맨 위에 `Part of #<map>`을 가지고 라벨 `유형:조사` / `유형:프로토타입` / `유형:인터뷰` / `유형:작업`을 단 이슈. 인계되면 티켓을 주도하는 개발자에게 할당한다.
- **차단**: 링크 API로 추가한다 — `glab api --method POST "projects/:id/issues/<child>/links" -F target_project_id=<id> -F target_issue_iid=<blocker> -F link_type=is_blocked_by`. **퀵 액션을 쓰지 않는다**: `/blocked_by`는 네이티브 차단이 없는 티어에서 인식되지 않아 본문 그대로 댓글로 올라간다. 위 호출이 `HTTP 400 link_type does not have a valid value`를 내면 그 인스턴스는 네이티브 차단이 없으므로(Free/CE), 설명의 `선행 작업` 섹션에 `#<n>` 목록으로만 기록한다. 모든 차단 이슈가 닫히면 티켓이 차단 해제된다.
- **프론티어 질의**: 맵의 하위로 제한한 `glab issue list -F json`을 가져와 열린 차단 — 열린 이슈에 대한 네이티브 `is_blocked_by` 링크(`glab api projects/:id/issues/:iid/links`) 또는 `선행 작업` 섹션의 열린 이슈 — 이나 담당자가 있는 것을 빼고, 맵 순서가 빠른 것이 우선한다.
- **인계**: `glab issue update <n> --assignee @me` — 세션의 첫 기록.
- **조사 인계 해제**: 차팅 중 완전한 결과와 조사 기록 포인터가 저장된 뒤 `glab issue update <n> --assignee=-@me`를 실행한다(필요 시 `@me`를 세션의 실제 사용자 이름으로 바꾼다). 조사 이슈는 열어두고 맵 gist를 추가하지 않는다. 저장이 실패하거나 세션이 미완료 작업을 넘기면 담당자를 유지한다.
- **해결**: `glab issue note <n> --message "<답안>"`, 그리고 `glab issue close <n>`, 그리고 맵의 Decisions-so-far에 컨텍스트 포인터(gist + 링크)를 덧붙인다.

## 조사 기록 저장

- 호출자가 출처 인용을 포함한 완전한 결과를 같은 조사 이슈에 전용 노트 하나로 올린다. 이후 세션이 불변 이슈 신원으로 찾을 수 있도록 `<!-- vibe-deep-plan research: <map-issue>/<ticket-issue> -->`로 시작한다.
- 노트가 제공자 한도를 넘으면 순서 노트(`Research record 1/N`, `2/N`, ...)나 프로젝트 위키, 스니펫, 첨부, 동등한 영속 산출물을 사용하고 이슈 노트에서 그 기록을 링크한다. 결과를 자르거나 로컬 파일에만 두지 않는다.
- 티켓에 `Research record: <노트 또는 산출물 URL>`을 기록한다. 호스팅 조사는 `Branch`, `Commit`, `Path` 포인터가 없으며 `research/...` 브랜치를 만들거나 푸시하지 않는다.
- 차팅 중에는 조사 이슈를 열어두고 맵 gist를 추가하지 않는다. 저장 성공 후 `glab issue update <n> --assignee=-@me`로 세션 인계만 해제한다(필요 시 `@me`를 세션의 실제 사용자 이름으로 바꾼다). 저장이 실패하면 이슈 인계를 유지한다. 다시 실행하기 전에 기존 노트와 링크된 산출물을 먼저 확인한다.
