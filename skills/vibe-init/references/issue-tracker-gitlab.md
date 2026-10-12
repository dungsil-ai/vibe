# 이슈 트래커: GitLab

이 저장소의 이슈와 제품 요구 문서(PRD)는 GitLab 이슈로 관리된다. 모든 작업에 `gg` CLI를 사용한다.

## 한국어 작성

한국어 이슈, MR, 리뷰 또는 댓글의 초안을 쓰기 전에 설치된 `vibe-docs` 스킬을 읽고 `필수 적용 순서`를 따른다. `CONTEXT.md`, 이 주제를 다루는 아키텍처 결정 기록(ADR), `docs/agents/`에 정의된 도메인 용어와 라벨 문자열은 번역하거나 일반화하거나 중립화하지 않고 원래 표기를 그대로 쓴다.

## 규칙

- **이슈 생성**: `gg issue create --title "..." --description "..."`. 두 줄 이상의 설명에는 heredoc을 쓴다. `--description -`을 주면 편집기가 열린다.
- **이슈 읽기**: `gg issue view <number> --comments`. 기계 판독 출력에는 `-F json`을 쓴다.
- **이슈 목록**: `gg issue list -F json`에 알맞은 `--label` 필터를 적용한다.
- **이슈 댓글**: `gg issue note <number> --message "..."`. GitLab은 댓글을 "notes"라 부른다.
- **라벨 적용 / 제거**: `gg issue update <number> --label "..."` / `--unlabel "..."`. 라벨을 둘 이상 붙일 때는 쉼표로 구분하거나 플래그를 반복한다.
- **닫기**: `gg issue close <number>`. `gg issue close`는 닫는 댓글을 받지 않으므로 먼저 `gg issue note <number> --message "..."`로 설명을 올리고 닫는다.
- **머지 리퀘스트**: GitLab은 PR을 "merge requests"라 부른다. MR은 `gg mr create`로 만들고, `gg mr view`로 읽고, `gg mr note`로 댓글을 단다. `gg pr ...`와 같은 형태에서 `pr` 대신 `mr`, `comment`/`--body` 대신 `note`/`--message`를 쓴다.

저장소는 `git remote -v`에서 추론한다. 클론 안에서 `gg`를 실행하면 자동으로 처리된다.

## 외부 머지 리퀘스트를 기능 요청으로 취급하는 설정

**MR을 요청 표면으로: 아니오.** _(이 저장소가 외부 머지 리퀘스트를 기능 요청으로 취급하면 `yes`로 설정한다. `vibe-plan`의 트리아지 단계가 이 플래그를 읽는다.)_

`yes`로 설정하면 MR도 이슈와 같은 라벨과 상태를 쓰며, `gg mr` 동등 명령을 사용한다:

- **MR 읽기**: `gg mr view <number> --comments`와 diff용 `gg mr diff <number>`.
- **트리아지에 쓸 외부 MR 목록**: `gg mr list -F json`에서 작성자가 프로젝트 멤버도 소유자도 아닌 MR만 남긴다(유지보수자의 진행 중 작업이 아닌 기여자의 MR).
- **댓글 / 라벨 / 닫기**: `gg mr note`, `gg mr update --label`/`--unlabel`, `gg mr close`.

GitHub와 달리 GitLab은 이슈와 MR을 따로 번호 매기므로 `#42`는 유지보수자가 어느 표면을 뜻하는지 알면 모호하지 않다.

## 스킬이 "이슈 트래커에 게시"라고 말할 때

GitLab 이슈를 생성한다.

## 스킬이 "관련 티켓을 가져오라"고 말할 때

`gg issue view <number> --comments`를 실행한다.

## 닫기 참조를 넣어 MR을 게시하는 방법

이 절은 독립 실행 `/vibe-implement`가 MR을 게시할 때 적용한다. 사람이 UI에서 **Merge**를 누르는 행위가 닫기 승인이다. 리뷰 통과는 승인이 아니다.

**자격 조건.** 여섯이 모두 참일 때만 closing pattern을 쓴다:

1. 이 저장소가 호스팅 트래커(GitLab 이슈)를 쓴다.
2. MR 대상 브랜치가 **MR이 머지될 대상 프로젝트**의 기본 브랜치다. 대상 프로젝트는 MR을 게시할 때 `gg mr create`가 출력하는 MR URL에서 읽는다: URL의 `<group>/<project>/-/merge_requests/<iid>`가 대상 프로젝트와 MR IID다. URL의 경로로 대상 프로젝트를 고정해 `gg mr view <IID> -R <target-project> -F json --jq '{target_branch, target_project_id}'`로 대상을 확인하고, `gg api projects/<target_project_id> | jq '{path_with_namespace, default_branch, autoclose_referenced_issues}'`로 기본 브랜치와 자동 닫기 설정을 읽는다. 대상 프로젝트를 알기 전에는 `gg mr view`를 실행하지 않는다. 포크 클론에서는 `git remote -v`가 소스 프로젝트인 포크를 골라 대상 프로젝트의 MR을 볼 수 없다. 포크 MR에서는 `projects/:id`가 포크 프로젝트를 가리키므로 쓰지 않는다.
3. **대상 이슈가 속한 프로젝트**에서 자동 닫기가 켜져 있어야 한다. 먼저 이슈 프로젝트 경로를 API에서 쓸 수 있는 형태로 고정한다. 숫자 `<issue-project-id>`를 기록하거나 네임스페이스 경로를 `%2F`로 URL로 인코딩한 `<group>%2F<project>`를 쓴다. 인코딩하지 않은 `<group>/<project>`를 API 경로에 넣지 않는다.

   `/`가 경로 구분자로 처리되면 다른 API 경로를 호출한다. 같은 프로젝트면 `<issue-project-id>`는 2의 `target_project_id`이고, 2에서 받은 `projects/<target_project_id>` 응답의 `autoclose_referenced_issues`를 그대로 읽는다. 다른 프로젝트면 그 프로젝트를 따로 조회해 숫자 ID와 설정을 함께 기록한다: `gg api projects/<group>%2F<project> | jq '{id, autoclose_referenced_issues}'` (`gg api`에는 `--jq` 플래그가 없어 파이프로 넘긴다). 이후 모든 이슈, 멤버, 커밋 API 호출에는 숫자 ID나 `%2F`로 인코딩한 경로만 쓴다.

   API용 숫자 ID나 인코딩 경로와 별개로, 트래커에 직접 쓸 때 필요한 이슈 소유 프로젝트의 `path_with_namespace` 전체 경로 `<issue-project>`도 기록한다. `-R`은 인코딩하지 않은 이 경로만 받으므로 숫자 ID나 `%2F`로 인코딩한 경로를 주지 않는다. 다른 프로젝트면 조회 결과에 `path_with_namespace`를 포함한다: `gg api projects/<group>%2F<project> | jq '{id, path_with_namespace, autoclose_referenced_issues}'`.
4. 머지를 누를 사람이 정해져 있어야 한다. 에이전트는 그 사람에게 대상 이슈를 닫을 권한이 있는지 미리 확인한다. 다음 중 하나를 증명하면 자격이 있다: (a) 그 사람이 대상 이슈의 author이거나 assignee다: `gg api projects/<issue-project-id>/issues/<iid> | jq '{author: .author.username, assignees: [.assignees[].username]}'`. (b) 이슈 프로젝트에서 그 사람의 access level이 Planner(15) 이상이다: `gg api "users?username=<user>" | jq '.[0].id'`, 그리고 `gg api projects/<issue-project-id>/members/all/<user-id> | jq '{access_level}'`. author나 assignee면 멤버십 조회가 없어도, 실패해도 자격이 있다. 이슈 프로젝트의 멤버가 아니어도 된다. 머지를 누를 사람이 미정이거나 에이전트가 (a)와 (b) 중 어느 권한도 증명하지 못하면 자격이 없다. 에이전트는 권한을 추정하지 않는다.
5. 머지하면 인수 조건이 모두 끝나는 구현 티켓이 **정확히 하나**다.
6. 기본 자동 닫기 기능을 쓸 수 있는 상태로 MR을 넘기기 전에 이 인스턴스가 이슈를 닫는 정확한 정규식을 확인해 기록했다. GitLab.com(SaaS)은 기본 정규식을 쓴다. 자체 관리형 인스턴스에서는 Omnibus 설정의 `/etc/gitlab/gitlab.rb`에 있는 `gitlab_rails['gitlab_issue_closing_pattern']` 또는 소스 설치의 `gitlab.yml`에 있는 `issue_closing_pattern`에서 정규식을 확인하거나 관리자에게 정확한 정규식을 요청한다. 정규식을 알 수 없으면 작업을 즉시 중단한다. 닫기 키워드를 넣어 게시하지 않고 머지나 수동 닫기 요청도 하지 않는다. 이미 키워드를 게시했다면 정확한 정규식으로 직접 확인해 자동 닫기 위험이 남지 않았음을 증명하기 전에는 머지하거나 `gg issue close`를 실행하지 않는다.

2와 3은 프로젝트가 다를 수 있으므로 따로 확인한다. 기본 브랜치는 MR이 머지될 대상 프로젝트에서 읽고, 자동 닫기 설정은 이슈 소유 프로젝트에서 읽는다. `autoclose_referenced_issues`가 `false`면 참조만 남고 닫히지 않는다.

**게시 정보를 기록하고 프로젝트를 고정한다.** MR을 게시하면 대상 프로젝트의 `path_with_namespace` 전체 경로와 숫자 `target_project_id`, MR IID를 기록한다. 값은 2의 `gg api projects/<target_project_id>` 응답에서 읽는다.

이후 모든 `gg mr view`, `gg mr issues`, `gg mr update`에 `-R <target-project>`를 붙인다. 포크를 체크아웃한 클론에서 `-R` 없이 실행하면 `gg`가 `git remote -v`로 소스 프로젝트인 포크를 골라, 대상 프로젝트가 아니라 포크를 읽고 고친다. `-R`은 경로(`<group>/<project>`)만 받고 `gg api`에는 `-R`이 없으므로, 숫자 ID는 `gg api projects/<target_project_id>/...` 경로에 쓴다. 기록한 IID는 대상 프로젝트에서 본 MR IID이며, 소스 프로젝트의 번호가 아니다.

**이슈 프로젝트도 기록한다.** 이슈가 MR과 같은 프로젝트에 있거나 다른 프로젝트에 있어도, 이슈 소유 프로젝트의 인코딩하지 않은 `path_with_namespace` 전체 경로 `<issue-project>`를 기록한다. 이 경로는 `gg issue ... -R <issue-project>`에 쓰며 대상 프로젝트와 같아도 생략하지 않는다.

**참조 문법**

- 같은 프로젝트: MR 설명에 `Closes #<iid>` 한 줄.
- 다른 프로젝트: 전체 경로나 전체 URL에도 closing keyword를 앞에 붙인다: `Closes <group>/<project>#<iid>` 또는 `Closes https://gitlab.example.com/<group>/<project>/-/issues/<iid>`. keyword 없는 URL만 적으면 링크만 남고 닫히지 않는다.
- 기본 closing keyword는 `Close(s/d)`/`Closing`, `Fix(es/ed)`/`Fixing`, `Resolve(s/d)`/`Resolving`, `Implement(s/ed)`/`Implementing`이다. GitHub과 달리 `implement` 계열도 닫는다.
- 기본 패턴은 한 줄에 둘 이상의 참조를 나열하면 전부 닫는다(`Closes #4, #6`). 닫기 줄에는 티켓 하나만 적는다.
- 부모 명세 이슈는 절대 closing target이 아니다. `Part of #<parent>`로만 적는다.
- 닫지 않을 참조는 keyword 없이 `Related to #<n>` / `Refs #<n>`으로 적는다.
- 조사 / 프로토타입 / 인터뷰 티켓이나 머지 뒤에도 인수 조건이 남는 티켓(배포나 수동 확인이 그 예다)은 닫기 대상이 아니다.
- 커밋 메시지에는 닫기 키워드를 넣지 않는다. MR 제목에는 이슈 참조를 넣지 않는다. 제목에서 `#<iid>`, `<group>/<project>#<iid>`, 전체 이슈 URL을 모두 뺀다. 티켓 번호가 필요하면 설명에만 적는다.

  이 인스턴스의 닫기 정규식은 MR 설명과 브랜치 커밋 메시지를 함께 검사한다. 커밋 메시지에 남은 키워드는 설명 밖에서 의도하지 않은 닫기를 일으킨다. squash merge는 제목을 커밋 제목으로 쓰므로 제목의 남은 참조가 검증 뒤 닫기 정규식에 일치할 수 있다. 정규식을 몰라도 MR 제목에는 참조를 하나도 남기지 않는다.

**게시 뒤 대상을 검증한다.** 게시 직후에 실행해 위 조건을 전부 다시 확인한다. 모든 `gg mr` 명령은 기록한 `-R <target-project>`와 MR IID로 대상 프로젝트에 고정한다:

```bash
gg mr view <IID> -R <target-project> -F json --jq '{state, target_branch, target_project_id, title, description}'
gg api projects/<target_project_id> | jq '{path_with_namespace, default_branch, autoclose_referenced_issues}'
gg api projects/<issue-project-id> | jq '.autoclose_referenced_issues'   # 이슈가 다른 프로젝트일 때만 (숫자 id 또는 <group>%2F<project>)
gg api projects/<issue-project-id>/issues/<iid> | jq '{author: .author.username, assignees: [.assignees[].username]}'
gg api projects/<issue-project-id>/members/all/<merger-user-id> | jq '{access_level}'   # merge할 사람이 author도 assignee도 아닐 때만
gg api --paginate "projects/<target_project_id>/merge_requests/<IID>/commits?per_page=100" | jq -r '.[] | .title, .message'
gg mr issues <IID> -R <target-project>
```

**설명을 직접 검사한 결과를 주된 증거로 삼는다.** `gg mr view -F json`의 `description`에 확정한 정확한 닫기 정규식을 적용해 닫기 참조 수를 센다.
정확히 한 개만 있어야 하며, 그 참조는 의도한 티켓 하나를 가리켜야 한다. 같은 프로젝트에서는 `#<iid>`를 쓴다. 다른 프로젝트에서는 `<group>/<project>#<iid>`나 전체 URL을 쓴다. 추가 닫기 참조는 없어야 한다.

MR 제목에는 이슈 참조가, 모든 커밋 메시지에는 닫기 참조가 없어야 한다.

`gg mr issues <IID> -R <target-project>` 목록에는 권한 필터와 자격 조건이 적용되어 실제보다 적은 티켓이 나올 수 있다. 이 목록은 보조 증거로만 쓰고 의도한 티켓이 하나뿐이라는 근거로 단독 사용하지 않는다.

설명에서 의도한 참조 하나와 추가 참조 0개가 확인되지 않거나 목록이 비었는데 원인을 알 수 없으면 수동 닫기 절차로 간다.

**수동 닫기 절차.** 다음 조건에서는 자동 닫기를 쓰지 않는다. 대상 브랜치에 변경 사항이 반영됐다는 증거, 정확한 미리보기, 별도 승인을 받은 뒤 수동으로 닫는다:

- 이슈 프로젝트의 자동 close가 꺼져 있다(`autoclose_referenced_issues: false`).
- 대상 브랜치가 대상 프로젝트의 기본 브랜치가 아니다.
- 머지를 누를 사람이 미정이거나, 그 사람이 대상 이슈를 닫을 권한을 증명할 수 없다. 대상 이슈의 author도 assignee도 아니고, 이슈 프로젝트의 access level도 Planner(15) 미만이거나 조회로 확인되지 않는다.
- MR이 머지 없이 닫혔다. 자동 닫기는 일어나지 않고 이슈는 열린 상태다.
- `gg mr issues <IID> -R <target-project>`에서 오류가 나거나 티켓이 하나가 아니면 수동 닫기 절차로 간다. 원인은 맞춤 닫기 정규식이나 권한 부족일 수 있지만, CLI 출력만으로 진단하지 않는다. 이 목록에는 권한 필터와 자격 조건이 적용된다. 조건이 꺼졌거나 권한이 부족하면 닫기 정규식이 남아 있어도 티켓이 빠지거나 목록 수가 줄 수 있다. 따라서 이 목록을 정규식 검사로 쓰지 않는다.
- 닫을 대상 티켓이 정확히 하나가 아니다(0개, 둘 이상이거나 부모 이슈만 있다).
- 설명 직접 확인에서 의도한 닫기 참조가 하나만 나오지 않는다. 참조가 0개면 이슈가 닫히지 않거나 정규식이 맞지 않을 수 있다. 참조가 다른 티켓을 가리키면 조건을 만족하지 않는다. 추가 참조가 하나라도 있으면 의도하지 않은 이슈를 닫을 위험이 있다.

**수동 닫기도 이슈 소유 프로젝트에서 실행한다.** 수동 닫기 댓글과 닫기 동작은 MR 프로젝트가 아니라 이슈를 소유한 프로젝트에서 실행한다. 3번에서 기록한 인코딩하지 않은 `<issue-project>`를 `-R`에 준다. 이슈가 MR과 같은 프로젝트에 있거나 다른 프로젝트에 있어도 `-R`을 명시한다:

- `gg issue note <iid> -R <issue-project> --message "..."`
- `gg issue close <iid> -R <issue-project>`

`-R` 없이 실행하면 `git remote -v`의 클론(fork나 target)이 골라져 다른 프로젝트의 같은 번호 이슈에 댓글을 쓰거나 닫을 수 있다. 이슈 IID는 기록한 `<issue-project>`의 번호다.

**수동 닫기 절차로 바뀌면 자동 닫기를 완전히 제거한다.** `gg mr issues`가 추가 이슈를 보이거나 위 수동 닫기 조건을 하나라도 만족하면, 수동으로 닫기 전에 다음 작업을 끝낸다. 모든 `gg mr` 명령에는 기록한 `-R <target-project>`와 MR IID를 쓴다:

1. MR 제목에서 이슈 참조를 모두 지운다. `gg mr update <IID> -R <target-project> --title "<새 제목>"`로 제목을 갱신한다. squash merge는 제목을 커밋 제목으로 쓰므로 `#<iid>`, `<group>/<project>#<iid>`, 전체 이슈 URL을 모두 제거한다. 티켓 번호가 필요하면 설명에만 적는다.
2. MR 설명에서는 닫기 키워드만 `Refs`로 바꾸고 `gg mr update <IID> -R <target-project> --description "<새 본문>"`로 갱신한다. `Close(s/d)`/`Closing`, `Fix(es/ed)`/`Fixing`, `Resolve(s/d)`/`Resolving`, `Implement(s/ed)`/`Implementing`과 알려진 맞춤 닫기 키워드에 이 규칙을 적용한다. 설명의 참조는 그대로 둔다. 같은 프로젝트 `#<iid>`, 다른 프로젝트 `<group>/<project>#<iid>`, 전체 URL을 모두 보존한다. `Closes <group>/<project>#12` → `Refs <group>/<project>#12`와 `Closes https://gitlab.example.com/<group>/<project>/-/issues/<iid>` → `Refs https://gitlab.example.com/<group>/<project>/-/issues/<iid>`가 그 예다. 맞춤 정규식을 모르면 3번에 따라 중단한다.
3. 자체 관리형 인스턴스에서 맞춤 정규식을 확인할 수 없으면 머지와 수동 닫기 요청을 중단한다. 정확한 정규식으로 직접 확인해 닫기 조건이 0임을 증명하기 전에는 `gg issue close`를 실행하지 않는다. 기본 정규식만 확인한 결과를 설명이나 커밋 메시지에서 닫기 조건이 사라졌다는 증거로 쓰지 않는다. 제목 참조 0 검사는 정규식과 무관하므로 별도로 수행한다.
4. 다른 사람의 커밋이 있거나 보호된 브랜치이거나 강제 push가 막혔거나 fork에 push 권한이 없어 이력을 안전하게 다시 쓸 수 없으면 머지 요청을 중단한다. 남은 자동 닫기 위험을 사람에게 알린다. 확인되지 않은 자동 닫기 상태로 머지를 넘기지 않는다.
5. 모든 커밋 메시지에서 닫기 정규식에 맞는 키워드만 `Refs`로 바꾼다. 다른 프로젝트 경로와 URL을 포함한 모든 이슈 참조는 보존한다. 맞춤 정규식을 모르면 3번에 따라 중단한다.
6. 브랜치 커밋 메시지를 다시 쓴다. 커밋이 둘 이상이면 `git rebase -i`를 쓰고 마지막 커밋만 바꾸면 `git commit --amend`를 쓴다.
7. 원격 브랜치 기록을 덮어쓰며 복구하지 못할 수 있음을 사용자에게 먼저 알린 뒤, `git push --force-with-lease`로 push한다.
8. 대상 프로젝트 MR의 제목과 설명, 모든 커밋 메시지를 가져온다:
   ```bash
   gg mr view <IID> -R <target-project> -F json --jq '{title, description}'
   gg api --paginate "projects/<target_project_id>/merge_requests/<IID>/commits?per_page=100" | jq -r '.[] | .title, .message'
   ```

커밋 엔드포인트는 처음에 20개만 반환한다. 첫 페이지만 읽으면 뒤쪽 커밋의 키워드를 놓치므로 `--paginate`로 마지막 페이지까지 가져온다.
제목에서는 이슈 참조 수만 세므로 정규식을 몰라도 판정할 수 있다.

설명과 커밋 메시지는 기본 닫기 키워드와 이 인스턴스의 맞춤 닫기 정규식으로 검사한다. 맞춤 정규식을 조회할 API는 없다. GitLab.com(SaaS)은 기본 정규식을 쓴다.

자체 관리형 인스턴스에서는 Omnibus 설정의 `/etc/gitlab/gitlab.rb`에 있는 `gitlab_rails['gitlab_issue_closing_pattern']` 또는 소스 설치의 `gitlab.yml`에 있는 `issue_closing_pattern`에서 정규식을 확인한다. 관리자에게 정확한 정규식을 받아도 된다.

기본 정규식은 키워드 뒤에 `:`나 `issue`, `issues`가 끼어도 찾는다(`Closes: #4`, `Fixes issue #4`). `#<iid>`, `<group>/<project>#<iid>`, 전체 이슈 URL을 모두 검사한다.

9. 정확한 맞춤 정규식을 설명과 모든 커밋 메시지에 적용해 닫기 키워드가 붙은 이슈 참조 수를 센다. 그 수는 0개여야 한다. MR 제목에는 이슈 참조가 없어야 한다.
10. 자격 조건이 실제로 켜졌을 때만 `gg mr issues <IID> -R <target-project>`의 **빈** 목록을 추가 증거로 쓴다. 대상 브랜치가 대상 프로젝트의 기본 브랜치이고 이슈 프로젝트의 `autoclose_referenced_issues: true`일 때만 자격 조건이 켜진다.
   자격 조건이 꺼져 있으면 닫기 정규식이 남아 있어도 목록이 비어 있을 수 있다. 따라서 빈 목록만으로 제거를 입증하지 않는다. 그때는 9번의 직접 확인만 증거로 쓴다.

**Merge when pipeline succeeds**를 켜면 닫힐 이슈 목록이 고정되므로, 켜기 전에 위 검증을 끝낸다.

## 경로 탐색 작업

`/vibe-deep-plan`이 사용한다. **맵**은 티켓을 **하위 이슈**로 가진 단일 이슈이다.

- **맵**: `상태:초안`과 `유형:계획` 라벨이 붙은 단일 이슈로 Notes / Decisions-so-far / Fog 본문을 가진다. `gg issue create --label "상태:초안" --label "유형:계획"`. (네이티브 에픽이 있는 GitLab 티어에서는 에픽이 맵을 대신할 수 있다. 라벨이 붙은 이슈는 어디서든 작동한다.)
- **하위 티켓**: 설명 맨 위에 `Part of #<map>`을 넣고 라벨 `유형:조사` / `유형:프로토타입` / `유형:인터뷰` / `유형:작업`을 단 이슈다. 담당자를 지정할 때는 티켓을 주도하는 개발자에게 할당한다.
- **차단**: `gg api --method POST "projects/:id/issues/<child>/links" -F target_project_id=<id> -F target_issue_iid=<blocker> -F link_type=is_blocked_by`를 실행해 링크 API로 추가한다. **퀵 액션을 쓰지 않는다**: `/blocked_by`는 네이티브 차단이 없는 티어에서 인식되지 않아 본문 그대로 댓글로 올라간다. 위 호출이 `HTTP 400 link_type does not have a valid value`를 내면 그 인스턴스는 네이티브 차단이 없으므로(Free tier 또는 Community Edition), 설명의 `선행 작업` 섹션에 `#<n>` 목록으로만 기록한다. 모든 차단 이슈가 닫히면 티켓이 차단 해제된다.
- **프론티어 질의**: 맵의 하위로 제한한 `gg issue list -F json`을 가져온다. 열린 차단이 있거나 담당자가 있는 이슈를 뺀 뒤 맵 순서가 빠른 것을 우선한다. 열린 차단은 열린 차단 이슈를 가리키는 네이티브 `is_blocked_by` 링크(`gg api projects/:id/issues/:iid/links`) 또는 `선행 작업` 섹션에 적은 열린 이슈다.
- **담당자 지정**: `gg issue update <n> --assignee @me`를 세션의 첫 기록으로 실행한다.
- **조사 담당자 지정 해제**: 차팅 중에는 완전한 결과와 조사 기록 포인터를 저장한 뒤 `gg issue update <n> --assignee=-@me`를 실행한다(필요 시 `@me`를 세션의 실제 사용자 이름으로 바꾼다). 조사 이슈는 열어두고 맵 gist를 추가하지 않는다. 저장이 실패하거나 세션을 마칠 때 미완료 작업이 남으면 담당자를 유지한다.
- **해결**:
  1. `gg issue note <n> --message "<답안>"`으로 답변을 노트에 남긴다.
  2. `gg issue close <n>`을 실행한다.
  3. 맵의 Decisions-so-far에 컨텍스트 포인터(gist + 링크)를 덧붙인다.

## 조사 기록 저장

- 호출자가 출처 인용을 포함한 완전한 결과를 같은 조사 이슈에 전용 노트 하나로 올린다. 이후 세션이 불변 이슈 신원으로 찾을 수 있도록 `<!-- vibe-deep-plan research: <map-issue>/<ticket-issue> -->`로 시작한다.
- 노트가 제공자 한도를 넘으면 순서 노트(`Research record 1/N`, `2/N`, ...)나 프로젝트 위키, 스니펫, 첨부, 동등한 영속 산출물을 사용하고 이슈 노트에서 그 기록을 링크한다. 결과를 자르거나 로컬 파일에만 두지 않는다.
- 티켓에 `Research record: <노트 또는 산출물 URL>`을 기록한다. 호스팅 조사는 `Branch`, `Commit`, `Path` 포인터가 없으며 `research/...` 브랜치를 만들거나 푸시하지 않는다.
- 차팅 중에는 조사 이슈를 열어두고 맵 gist를 추가하지 않는다. 저장에 성공하면 `gg issue update <n> --assignee=-@me`로 담당자 지정을 해제한다(필요 시 `@me`를 세션의 실제 사용자 이름으로 바꾼다). 저장에 실패하면 이슈 담당자를 유지한다. 다시 실행하기 전에 기존 노트와 연결된 산출물을 먼저 확인한다.
