# 이슈 트래커: GitLab

이 저장소의 이슈와 PRD는 GitLab 이슈로 관리된다. 모든 작업에 [`glab`](https://gitlab.com/gitlab-org/cli) CLI를 사용한다.

## 한국어 작성

한국어 이슈, MR, 리뷰 또는 댓글의 초안을 쓰기 전에 설치된 `vibe-docs` 스킬을 읽고 `필수 적용 순서`를 따른다. `CONTEXT.md`, 관련 ADR, `docs/agents/`에 정의된 도메인 용어와 라벨 문자열은 번역하거나 일반화하거나 중립화하지 않고 원래 표기를 그대로 쓴다.

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

## 자동 close 참조로 MR 게시

독립 실행 `/vibe-implement`가 MR을 게시할 때 쓴다. 사람이 UI에서 **Merge**를 누르는 것이 close 승인이다 — 리뷰 통과는 승인이 아니다.

**자격 조건.** 여섯이 모두 참일 때만 closing pattern을 쓴다:

1. 이 저장소가 호스팅 트래커(GitLab 이슈)를 쓴다.
2. MR 대상 브랜치가 **MR이 머지될 대상 프로젝트**의 default branch다. 대상 프로젝트는 MR을 게시할 때 `glab mr create`가 출력하는 MR URL에서 읽는다 — URL의 `<group>/<project>/-/merge_requests/<iid>`가 대상 프로젝트와 MR IID다. URL의 경로로 대상 프로젝트를 고정해 `glab mr view <IID> -R <target-project> -F json --jq '{target_branch, target_project_id}'`로 target을 확인하고, `glab api projects/<target_project_id> | jq '{path_with_namespace, default_branch, autoclose_referenced_issues}'`로 default branch와 자동 close 설정을 읽는다. 대상 프로젝트를 알기 전에는 `glab mr view`를 실행하지 않는다 — fork 클론에서는 `git remote -v`가 source(fork)를 골라 대상 프로젝트의 MR을 볼 수 없다. fork MR에서는 `projects/:id`가 fork를 가리키므로 쓰지 않는다.
3. **대상 이슈가 속한 프로젝트**의 자동 close가 켜져 있다. 이슈 프로젝트는 API 경로에 바로 쓸 수 있는 형태로 먼저 고정한다 — 숫자 `<issue-project-id>`를 기록하거나, namespaced path를 `%2F`로 URL encode한 `<group>%2F<project>`를 쓴다. `<group>/<project>`를 날것으로 경로에 넣지 않는다 — `/`가 경로 구분자로 해석돼 엉뚱한 엔드포인트를 때린다. 같은 프로젝트면 `<issue-project-id>`는 2의 `target_project_id`이고, 2에서 받은 `projects/<target_project_id>` 응답의 `autoclose_referenced_issues`를 그대로 읽는다. 다른 프로젝트면 그 프로젝트를 따로 조회해 숫자 id와 설정을 함께 기록한다 — `glab api projects/<group>%2F<project> | jq '{id, autoclose_referenced_issues}'` (`glab api`에는 `--jq` 플래그가 없어 파이프로 넘긴다). 이후 모든 이슈 / 멤버 / 커밋 API 호출은 숫자 id나 `%2F`로 encode한 경로만 쓴다.
   API용 숫자 id/encode 경로와 별개로, 수동 tracker write에 쓸 이슈 소유 프로젝트의 raw `path_with_namespace` 전체 경로 `<issue-project>`도 기록한다. `-R`은 이 raw path만 받으므로 숫자 id나 `%2F` encode 경로를 주지 않는다. 다른 프로젝트면 조회 결과에 `path_with_namespace`를 포함한다 — `glab api projects/<group>%2F<project> | jq '{id, path_with_namespace, autoclose_referenced_issues}'`.
4. merge를 누를 사람이 정해져 있고, 그 사람이 **대상 이슈를 닫을 권한**을 가진 것이 사전에 확인된다. 다음 중 하나를 증명하면 자격이 있다 — (a) 그 사람이 대상 이슈의 author이거나 assignee다: `glab api projects/<issue-project-id>/issues/<iid> | jq '{author: .author.username, assignees: [.assignees[].username]}'`. (b) 이슈 프로젝트에서 그 사람의 access level이 Planner(15) 이상이다: `glab api "users?username=<user>" | jq '.[0].id'`, 그리고 `glab api projects/<issue-project-id>/members/all/<user-id> | jq '{access_level}'`. author나 assignee면 멤버십 조회가 없어도, 실패해도 자격이 있다 — 이슈 프로젝트의 멤버가 아니어도 된다. merge할 사람이 미정이거나 (a)와 (b) 어느 쪽도 증명되지 않으면 자격 없음이다. 권한을 증명하지 못하면 추정하지 않는다.
5. merge로 acceptance가 끝나는 구현 티켓이 **정확히 하나**다.
6. 네이티브 eligible handoff 전에 이 인스턴스의 **정확한 issue-closing regex**를 확정하고 그대로 기록했다. GitLab.com(SaaS)은 GitLab.com의 default regex를 쓰고, self-managed 인스턴스는 instance config(Omnibus `/etc/gitlab/gitlab.rb`의 `gitlab_rails['gitlab_issue_closing_pattern']`; source 설치 `gitlab.yml`의 `issue_closing_pattern`)나 administrator에게서 exact regex를 받는다. 알 수 없으면 **hard stop**이다: closing keyword를 넣어 게시하지 않고, merge 또는 manual-close handoff도 진행하지 않는다. 이미 keyword를 게시했다면 그 exact regex로 직접 scan해 residual auto-close risk가 0임을 증명하기 전에는 merge나 `glab issue close`를 진행하지 않는다.

2와 3은 프로젝트가 다를 수 있으므로 항상 별개로 확인한다: default branch는 MR이 머지될 대상 프로젝트에서, 자동 close 설정은 이슈가 속한 프로젝트에서 읽는다. `autoclose_referenced_issues`가 `false`면 참조만 남고 닫히지 않는다.

**게시 기록과 프로젝트 고정.** MR을 게시하면 두 값을 기록한다 — **대상 프로젝트**(위 2의 `glab api projects/<target_project_id>` 응답에서 읽은 `path_with_namespace` 전체 경로 `<group>/<project>`와 숫자 `target_project_id`)와 **MR IID**. 이후 모든 `glab mr view`, `glab mr issues`, `glab mr update`에 `-R <target-project>`를 붙인다. fork를 체크아웃한 클론에서 `-R` 없이 실행하면 `glab`이 `git remote -v`로 source(fork) 프로젝트를 골라, MR이 머지될 대상 프로젝트가 아니라 fork를 읽고 고친다. `-R`은 경로만 받으므로(`<group>/<project>`) 숫자 id는 `glab api projects/<target_project_id>/...` 경로에 쓴다 — `glab api`에는 `-R`이 없다. 기록한 IID는 대상 프로젝트에서 본 MR IID이며, source project의 번호가 아니다.
**이슈 프로젝트도 기록한다.** 같은 프로젝트와 cross-project 모두 이슈를 소유한 프로젝트의 raw `path_with_namespace` `<issue-project>`을 기록한다. 이 값은 `glab issue ... -R <issue-project>`에 쓰며 target project와 같아도 생략하지 않는다.

**참조 문법**

- 같은 프로젝트: MR 설명에 `Closes #<iid>` 한 줄.
- 다른 프로젝트: 전체 경로나 전체 URL에도 closing keyword를 앞에 붙인다 — `Closes <group>/<project>#<iid>` 또는 `Closes https://gitlab.example.com/<group>/<project>/-/issues/<iid>`. keyword 없는 URL만 적으면 링크만 남고 닫히지 않는다.
- 기본 closing keyword는 `Close(s/d)`/`Closing`, `Fix(es/ed)`/`Fixing`, `Resolve(s/d)`/`Resolving`, `Implement(s/ed)`/`Implementing`이다. GitHub과 달리 `implement` 계열도 닫는다.
- 기본 패턴은 한 줄에 여러 참조를 나열하면 전부 닫는다(`Closes #4, #6`) — closing 줄에는 티켓 하나만 적는다.
- 부모 명세 이슈는 절대 closing target이 아니다 — `Part of #<parent>`로만 적는다.
- 닫지 않을 참조는 keyword 없이 `Related to #<n>` / `Refs #<n>`으로 적는다.
- 조사 / 프로토타입 / 인터뷰 티켓과 merge 뒤에도 acceptance가 남는 티켓(배포, 수동 확인 등)은 closing target이 아니다.
- 커밋 메시지에는 closing keyword를 쓰지 않고, **MR 제목에는 어떤 이슈 참조도 넣지 않는다** — keyword가 있든 없든 `#<iid>`, `<group>/<project>#<iid>`, 전체 이슈 URL 전부 제목에서 뺀다. 인스턴스 closing pattern은 MR 설명과 브랜치 커밋 메시지를 함께 살피므로 커밋에 남은 keyword는 설명 밖에서 의도치 않은 close를 만든다. squash merge는 MR 제목을 커밋 subject로 쓰므로, 제목에 남은 참조는 검증이 끝난 뒤 merge 시점에 커밋 메시지가 되어 기본 pattern이든 인스턴스 커스텀 pattern이든 걸릴 수 있다. 그래서 제목은 pattern을 몰라도 판정되도록 참조 개수 0으로 맞춘다 — 티켓 번호가 필요하면 설명에만 적는다.

**게시 뒤 대상 검증.** 게시 직후에 실행해 위 조건을 전부 다시 확인한다. 모든 `glab mr` 명령은 기록한 `-R <target-project>`와 MR IID로 대상 프로젝트에 고정한다:

```bash
glab mr view <IID> -R <target-project> -F json --jq '{state, target_branch, target_project_id, title, description}'
glab api projects/<target_project_id> | jq '{path_with_namespace, default_branch, autoclose_referenced_issues}'
glab api projects/<issue-project-id> | jq '.autoclose_referenced_issues'   # 이슈가 다른 프로젝트일 때만 (숫자 id 또는 <group>%2F<project>)
glab api projects/<issue-project-id>/issues/<iid> | jq '{author: .author.username, assignees: [.assignees[].username]}'
glab api projects/<issue-project-id>/members/all/<merger-user-id> | jq '{access_level}'   # merge할 사람이 author도 assignee도 아닐 때만
glab api --paginate "projects/<target_project_id>/merge_requests/<IID>/commits?per_page=100" | jq -r '.[] | .title, .message'
glab mr issues <IID> -R <target-project>
```

**설명은 직접 스캔이 primary다.** `glab mr view -F json`의 `description`에 확정한 exact closing regex를 적용해 closing match 수를 센다 — match는 **정확히 1개**이고, 그 참조가 의도한 티켓 하나(같은 프로젝트 `#<iid>`든 cross-project 경로 `<group>/<project>#<iid>`든 전체 URL이든)이며, **추가 closing match는 0개**여야 한다. MR 제목의 이슈 참조는 0개이고(kw 없이도 참조만으로 0 판정), 모든 커밋 메시지의 closing match는 0개다. `glab mr issues <IID> -R <target-project>`의 정확히-one 목록은 **supplementary provider evidence로만** 유지한다 — 이 목록은 permission filtering과 자격 gate 양쪽에 걸려 under-report하므로, 의도한 티켓의 유일성 증거로 단독 신뢰하지 않는다. description이 정확히 1개 의도한 match + 0 extra가 아니면, 또는 목록이 permission 때문에 비었는지 pattern 때문에 비었는지 알 수 없으면 폴백으로 간다.

**폴백.** 다음에는 자동 close를 쓰지 않고, landing proof + 정확한 미리보기 + 별도 승인으로 수동 close한다:

- 이슈 프로젝트의 자동 close가 꺼져 있다(`autoclose_referenced_issues: false`).
- 대상 브랜치가 대상 프로젝트의 default branch가 아니다.
- merge를 누를 사람이 미정이거나, 그 사람이 대상 이슈를 닫을 권한을 증명할 수 없다 — 대상 이슈의 author도 assignee도 아니고, 이슈 프로젝트의 access level도 Planner(15) 미만이거나 조회로 확인되지 않는다.
- MR이 merge 없이 close되었다 — 자동 close는 일어나지 않고 이슈는 열려 있다.

**수동 close 쓰기도 이슈 소유 프로젝트에 고정한다.** 수동 close의 comment/close는 MR 프로젝트가 아니라 **이슈를 소유한 프로젝트**에 쓴다 — 기록한 raw `<issue-project>`(3의 `path_with_namespace`)를 `-R`로 준다. 같은 프로젝트와 cross-project 모두 예외 없이 명시한다:

- `glab issue note <iid> -R <issue-project> --message "..."`
- `glab issue close <iid> -R <issue-project>`

`-R` 없이 실행하면 `git remote -v`의 클론(fork나 target)이 골라져 다른 프로젝트의 같은 번호 이슈에 댓글을 쓰거나 닫을 수 있다. 이슈 IID는 기록한 `<issue-project>`의 번호다.
- `glab mr issues <IID> -R <target-project>` 결과가 에러이거나 티켓이 하나가 아니다. 원인은 인스턴스 커스텀 closing pattern(인스턴스 설정)이나 권한 부족(머지하는 사람에게 권한이 없으면 GitLab이 close를 건너뛴다)일 수 있지만, CLI 출력만으로 원인을 진단하지 않는다. 이 목록은 permission filtering과 자격 gate 양쪽에 걸린다 — gate가 꺼져 있거나 권한이 부족하면 pattern이 남아 있어도 비거나 줄어든 목록이 나오므로, 목록 자체를 pattern 검사로 쓰지 않는다.
- closing 대상이 될 티켓이 정확히 하나가 아니다(0개, 여러 개, 또는 부모 이슈뿐).
- **설명 직접 스캔이 정확히 1개 의도한 match + 0 extra를 만족하지 못한다** — closing match가 0개(원하는 close가 안 되거나 regex가 틀렸을 수 있음), 그 참조가 의도한 티켓이 아님, 또는 추가 closing match가 하나라도 있음(의도치 않은 close 위험).

**폴백으로 바뀌면 자동 close를 완전히 제거한다.** `glab mr issues`가 추가 이슈를 보이거나 위 폴백 조건에 걸리면, 수동 close로 넘어가기 전에 다음을 끝낸다. 모든 `glab mr` 명령은 기록한 `-R <target-project>`와 MR IID를 쓴다:

1. MR 제목에서는 이슈 참조를 **참조까지 통째로** 없애고, 설명에서는 closing **keyword만** 없앤다 — 제목은 `glab mr update <IID> -R <target-project> --title "<새 제목>"`, 설명은 `glab mr update <IID> -R <target-project> --description "<새 본문>"`. 제목은 squash merge에서 커밋 subject가 되므로 keyword만 지우는 것으로 부족하다: `#<iid>`, `<group>/<project>#<iid>`, 전체 이슈 URL을 모두 제목에서 빼 참조 0으로 만들고, 티켓 번호가 필요하면 설명에만 남긴다. 설명에서는 `Close(s/d)`/`Closing`, `Fix(es/ed)`/`Fixing`, `Resolve(s/d)`/`Resolving`, `Implement(s/ed)`/`Implementing`을 `Refs`로 바꾸고, 이 인스턴스의 알려진 커스텀 closing keyword도 똑같이 keyword만 `Refs`로 바꾼다 — 커스텀 pattern을 모르면 아래 4에 따라 merge 인계를 중단한다. 설명의 참조는 원래 형태를 그대로 보존한다 — 같은 프로젝트 `#<iid>`, 다른 프로젝트 전체 경로 `<group>/<project>#<iid>`, 전체 URL을 모두 그대로 둔다(`Closes <group>/<project>#12` → `Refs <group>/<project>#12`, `Closes https://gitlab.example.com/<group>/<project>/-/issues/12` → `Refs https://gitlab.example.com/<group>/<project>/-/issues/12`). 설명의 참조를 지우거나 합치거나 같은 프로젝트 축약형으로 바꾸지 않고, 한 줄에 여러 참조가 있으면 **모든** 참조를 남긴다. `Part of #<parent>`는 그대로 둔다.
2. 커밋 메시지의 closing pattern도 **모두** 지운다. 여기서도 keyword만 `Refs`로 바꾼다(알려진 커스텀 closing keyword 포함 — 커스텀 pattern을 모르면 아래 4에 따라 중단). cross-project 경로와 URL을 포함한 모든 참조를 보존한다. 브랜치 커밋 메시지를 rewrite하고(`git rebase -i` 또는 마지막 커밋만이면 `git commit --amend`) `git push --force-with-lease`로 푸시한다.
3. 제거를 **직접 스캔으로** 확인한다. 대상 프로젝트 MR의 제목·설명과 모든 커밋 메시지를 가져와 **제목의 이슈 참조가 0개**이고, **설명과 모든 커밋 메시지의 (closing keyword) + (이슈 참조) 조합이 0개**임을 본다:

   ```bash
   glab mr view <IID> -R <target-project> -F json --jq '{title, description}'
   glab api --paginate "projects/<target_project_id>/merge_requests/<IID>/commits?per_page=100" | jq -r '.[] | .title, .message'
   ```

   commits 엔드포인트는 기본 page가 20개이므로 `--paginate`로 마지막 page까지 받는다 — 한 page만 읽으면 남은 커밋의 keyword를 놓친다. 제목 스캔은 참조 개수만 세므로 pattern을 몰라도 판정된다. 설명과 커밋 스캔에는 기본 keyword 계열 전부와 **이 인스턴스의 커스텀 closing pattern**을 함께 적용한다. 커스텀 pattern은 조회용 API가 없다 — gitlab.com(SaaS)은 기본 pattern이 그대로이고, self-managed 인스턴스는 instance config(Omnibus `/etc/gitlab/gitlab.rb`의 `gitlab_rails['gitlab_issue_closing_pattern']`, source 설치는 `gitlab.yml`의 `issue_closing_pattern`)나 administrator에게서 **정확한 regex**를 받아 그대로 기록한 뒤 스캔에 쓴다. 기본 pattern은 keyword 뒤에 `:`나 `issue`/`issues`가 끼어도 매치하고(`Closes: #4`, `Fixes issue #4`), 참조 형태로 `#<iid>`, `<group>/<project>#<iid>`, 전체 이슈 URL을 모두 받으므로 세 형태를 다 확인한다.
4. 커스텀 pattern을 알 수 없으면 — self-managed 인스턴스인데 instance config를 읽을 수 없고 administrator에게서도 정확한 regex를 받지 못하면 — **merge 및 manual-close 인계를 중단한다.** 직접 스캔으로 zero를 증명하기 전에는 `glab issue close`를 실행하지 않는다. 기본 pattern만 스캔한 결과를 설명·커밋의 제거 완료 증거로 쓰지 않는다. 제목의 참조 0 검사는 pattern과 무관하므로 이 중단과 별개로 그대로 지킨다.
5. 자격 gate가 실제로 켜져 있었을 때만(대상 브랜치 = 대상 프로젝트의 default branch **그리고** 이슈 프로젝트의 `autoclose_referenced_issues: true`) `glab mr issues <IID> -R <target-project>`의 **빈** 목록을 추가 증거로 쓴다. gate가 꺼져 있으면 이 목록은 pattern이 남아 있어도 비므로, 빈 목록만으로 제거 완료를 주장하지 않는다 — 그때는 3의 직접 스캔이 유일한 증거다.
6. 안전하게 rewrite할 수 없으면 — 다른 사람의 커밋 위에서 rewrite해야 하거나, 보호된 브랜치이거나, force push가 막혀 있거나, fork에 push 권한이 없으면 — **merge 인계를 중단한다.** 남은 자동 close 위험을 사람에게 보고하고, 검증되지 않은 자동 close를 남긴 채 merge를 넘기지 않는다.

**Merge when pipeline succeeds**를 켜면 닫힐 이슈 목록이 고정되므로, 켜기 전에 위 검증을 끝낸다.

## 경로 탐색 작업

`/vibe-deep-plan`이 사용한다. **맵**은 티켓을 **하위 이슈**로 가진 단일 이슈이다.

- **맵**: `상태:초안`과 `유형:계획` 라벨이 붙은 단일 이슈로 Notes / Decisions-so-far / Fog 본문을 가진다. `glab issue create --label "상태:초안" --label "유형:계획"`. (네이티브 에픽이 있는 GitLab 티어에서는 에픽이 맵을 대신할 수 있다. 라벨이 붙은 이슈는 어디서든 작동한다.)
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
