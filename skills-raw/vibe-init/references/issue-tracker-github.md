# 이슈 트래커: GitHub

이 저장소의 이슈와 PRD는 GitHub 이슈로 관리된다. 모든 작업에 `gh` CLI를 사용한다.

## 한국어 작성

한국어 이슈, PR, 리뷰 또는 댓글의 초안을 쓰기 전에 설치된 `vibe-docs` 스킬을 읽고 `필수 적용 순서`를 따른다. `CONTEXT.md`, 관련 ADR, `docs/agents/`에 정의된 도메인 용어와 라벨 문자열은 번역하거나 일반화하거나 중립화하지 않고 원래 표기를 그대로 쓴다.

## 규칙

- **이슈 생성**: `gh issue create --title "..." --body "..."`. 여러 줄 본문에는 heredoc을 쓴다.
- **이슈 읽기**: `gh issue view <number> --comments`로 댓글을 `jq`로 걸러내고 라벨도 함께 가져온다.
- **이슈 목록**: `gh issue list --state open --json number,title,body,labels,blockedBy,subIssues --jq '[.[] | {number, title, body, labels: [.labels[].name], blockedBy, subIssues}]'`에 알맞은 `--label`과 `--state` 필터를 적용한다. 댓글은 이 목록에서 가져오지 않는다 — `gh issue view <number> --comments`로만 읽는다.
- **이슈 댓글**: `gh issue comment <number> --body "..."`
- **라벨 적용 / 제거**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **닫기**: `gh issue close <number> --comment "..."`. 다른 저장소의 이슈면 `-R <owner>/<repo>`를 붙인다 — `gh`는 현재 클론의 remote에서 저장소를 추론하므로 빼면 이 저장소의 같은 번호 이슈를 닫는다.

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

## 자동 close 참조로 PR 게시

독립 실행 `/vibe-implement`가 PR을 게시할 때 쓴다. 사람이 UI에서 **Merge**를 누르는 것이 close 승인이다 — 리뷰 통과는 승인이 아니다.

**자격 조건.** 셋이 모두 참일 때만 closing keyword를 쓴다:

1. 이 저장소가 호스팅 트래커(GitHub 이슈)를 쓴다.
2. PR base가 저장소의 default branch다 — `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`으로 확인한다.
3. merge로 acceptance가 끝나는 구현 티켓이 **정확히 하나**다.

**참조 문법**

- 같은 저장소: PR 본문에 `Closes #<ticket>` 한 줄.
- 다른 저장소: `Closes <owner>/<repo>#<ticket>` 전체 참조. 그냥 `#<n>`은 다른 저장소를 가리키지 못한다.
- keyword는 `close` / `closes` / `closed` / `fix` / `fixes` / `fixed` / `resolve` / `resolves` / `resolved`이고 대문자와 콜론도 된다(`Closes: #10`). GitHub은 `implement` 계열을 keyword로 보지 않는다.
- 티켓 하나에 keyword 하나. 한 PR이 여러 티켓을 닫지 않는다.
- closing keyword는 **PR 본문에만** 둔다. PR title과 PR에 든 어떤 commit message에도 closing keyword가 없어야 한다 — squash merge는 PR title을 merge commit subject로 쓰고, commit message의 keyword도 default branch로 merge될 때 이슈를 닫는다. 그런데 둘 다 `closingIssuesReferences`에는 나타나지 않아서 "정확히 하나" 검증을 그냥 지나친다.
- 부모 명세 이슈는 절대 closing target이 아니다 — 같은 저장소면 `Part of #<parent>`, 다른 저장소면 `Part of <owner>/<repo>#<parent>`로만 적는다. cross-repo 부모를 그냥 `#<parent>`로 줄이지 않는다. 하위 이슈 링크나 작업 목록 체크는 close를 일으키지 않는다.
- GitHub UI의 **Development** 패널로 수동 연결한 이슈도 merge 때 닫히고 `closingIssuesReferences`에 나타난다. 의도한 티켓 외에는 수동 연결을 만들지 않는다.
- 조사 / 프로토타입 / 인터뷰 티켓과 merge 뒤에도 acceptance가 남는 티켓(배포, 수동 확인 등)은 closing target이 아니다 — 같은 저장소면 `Refs #<n>`, 다른 저장소면 `Refs <owner>/<repo>#<n>`으로 적는다.
- **downgrade는 keyword만 바꾼다.** closing 참조를 non-closing으로 낮출 때 keyword(`Closes` 계열)만 `Refs`로 바꾸고 이슈 참조는 글자 그대로 보존한다: `Closes #<n>` → `Refs #<n>`, `Closes <owner>/<repo>#<n>` → `Refs <owner>/<repo>#<n>`, `Closes https://github.com/<owner>/<repo>/issues/<n>` → `Refs https://github.com/<owner>/<repo>/issues/<n>`. 다른 저장소 참조를 그냥 `Refs #<n>`으로 줄이면 이 저장소의 같은 번호 이슈를 가리켜 티켓 신원을 잃는다 — 어느 저장소의 어느 이슈였는지 본문만으로는 복구할 수 없다. 아래 폴백과 `250 초과 hard stop`의 downgrade도 모두 이 규칙을 따른다.

**게시 뒤 대상 검증.** 게시 직후 두 명령을 모두 실행한다:

```bash
gh pr view <PR> --json baseRefName,closingIssuesReferences \
  --jq '{base: .baseRefName, closes: [.closingIssuesReferences[].url]}'
gh pr view <PR> --json body --jq .body
```

- `base`가 default branch 이름과 정확히 같아야 한다.
- `closes`의 길이가 정확히 1이고 그 URL이 의도한 티켓이어야 한다. 항목에는 `number`와 `repository.owner.login`도 있어 다른 저장소 대상도 확인할 수 있다.
- 길이가 0이면 링크가 없다 — 문법이나 base를 고친다. base가 default branch가 아니면 keyword는 무시되어 링크 자체가 생기지 않는다.
- 길이가 2 이상이면 먼저 여분 항목이 어디서 왔는지 가른다. PR 본문 keyword면 그 줄의 keyword만 `Refs`로 낮춘다 — 참조는 손대지 않으므로 같은 저장소 항목은 `Refs #<n>`, 다른 저장소 항목은 `Refs <owner>/<repo>#<n>`이 된다(`gh pr edit <PR> --body "..."`). UI Development 패널의 수동 link면 UI에서 unlink한다 — 본문 편집으로는 지워지지 않는다. 고친 뒤에는 이 검증만 다시 돌리지 않는다 — commit 수 확인부터 시작해 count → 본문 직접 scan + 본문 target 검증(수동 link 포함) → title 검사 → 전체 commit message 검사 순서로 전체 검증을 처음부터 다시 실행한다. count가 250을 넘으면 전체 commit message 검사로 가지 않고 `250 초과 hard stop` 절로 간다.
- 마지막 명령은 PR 본문 전체를 낸다. base나 link 상태와 무관하게 본문에서 closing keyword+이슈 참조 조합을 직접 세어, 의도한 한 줄 말고는 **0**인지 확인한다. base가 default branch가 아니면 keyword가 무시되어 `closingIssuesReferences`가 비므로 본문 잔여물이 그 목록에는 전혀 보이지 않는다 — 나중에 default branch로 retarget되면 그 잔여물이 그대로 발동해 이슈를 닫는다.
- 두 검증은 서로 다른 질문에 답한다. 본문 직접 scan은 **본문 잔여물**을, `closingIssuesReferences`는 **본문 연결 closing 참조 + UI Development 패널 수동 link**를 낸다. 본문 scan이 0인데 `closingIssuesReferences`가 비어 있지 않으면 남은 항목은 수동 link다 — UI에서 unlink한다.
- 이 목록은 **PR 본문의 closing keyword와 UI Development 패널의 수동 link**를 함께 반영한다. PR title과 commit message의 keyword는 여기에 나오지 않으므로 이 검증만으로는 숨은 close를 잡지 못한다. 반대로 여분 항목을 무조건 본문 keyword로 보고 본문만 고치면 수동 link는 그대로 남는다.

**게시 뒤 title / commit 수 확인.** 위 검증과 함께 두 명령을 모두 실행한다:

```bash
gh pr view <PR> --json title --jq .title
gh api 'repos/{owner}/{repo}/pulls/<PR>' --jq .commits
```

- 첫 명령은 PR title을 낸다. squash merge는 PR title을 merge commit subject로 쓰므로 title에 closing keyword와 이슈 참조가 함께 있으면 merge 때 이슈가 닫힌다.
- 둘째 명령은 PR의 전체 commit 수를 낸다. **250을 넘으면** REST pull-commits endpoint가 최대 250 commit까지만 돌려주므로 모든 commit message를 완전히 검증할 수 없다 — native 자동 close도 수동 close 폴백도 쓰지 않는다. 아래 **`250 초과 hard stop`** 절로 간다.
- 이 count 확인은 첫 게시에만 쓰는 것이 아니다. PR title / 본문 / commit message를 고쳐 다시 push한 **모든** 경로에서 이 명령을 **가장 먼저** 다시 실행한다 — rewrite는 commit 수를 바꾸므로 push 전 수치는 믿을 수 없고, 250 이하였던 PR이 rewrite로 250을 넘을 수 있다. 250을 넘으면 전체 commit message 검사를 계속하지 않고 바로 아래 **`250 초과 hard stop`** 절로 간다. 250 이하면 count → 본문 직접 scan + 본문 target 검증(수동 link 포함) → title 검사 → 전체 commit message 검사 순서로 전체 검증을 처음부터 다시 실행한다.

**게시 뒤 commit message 검사.** commit 수가 **250 이하일 때만** 실행한다:

```bash
gh api --paginate 'repos/{owner}/{repo}/pulls/<PR>/commits?per_page=100' --jq '.[].commit.message'
```

- 이 명령은 `--paginate`로 모든 commit page의 전체 message를 낸다. `gh pr view <PR> --json commits`는 첫 page만 주므로 commit이 100개를 넘는 PR에서 뒤쪽 page의 숨은 keyword를 놓친다 — 그래서 REST scan을 쓴다. 경로는 반드시 single quote로 감싸 shell이 `{owner}`/`{repo}`를 건드리지 않게 한다(`gh api`가 현재 클론에서 채운다). 다른 저장소면 `owner/repo`를 직접 적는다.
- title 출력과 commit message 출력 어디에도 closing keyword(`close` / `closes` / `closed` / `fix` / `fixes` / `fixed` / `resolve` / `resolves` / `resolved`, 대문자와 콜론 포함)와 이슈 참조가 함께 있으면 안 된다. commit message는 여러 줄이므로 keyword와 참조가 다른 줄에 있어도 같은 message 안이면 걸린 것으로 본다.
- 사람이 UI에서 merge title / merge message를 편집할 때도 의도한 PR 본문 link 외의 closing keyword+이슈 참조를 추가하지 않아야 한다. UI 편집분은 게시 뒤 검증 다음에 생겨 검사에 잡히지 않고 그대로 merge commit이 되어 다른 이슈까지 닫는다 — PR을 사람에게 넘길 때 이 점을 함께 알린다.
- 하나라도 걸리면 고쳐서 push한다: title은 `gh pr edit <PR> --title "..."`, 본문은 `gh pr edit <PR> --body "..."`, commit message는 rewrite(`git commit --amend` 또는 `git rebase -i`) 뒤 `--force-with-lease` push. 고친 다음에는 `gh api 'repos/{owner}/{repo}/pulls/<PR>' --jq .commits`로 전체 commit 수를 **가장 먼저** 다시 확인한다 — rewrite는 commit 수를 바꾸므로 고치기 전 수치는 믿을 수 없다. 250을 넘으면 전체 commit message 검사를 계속하지 않고 바로 `250 초과 hard stop` 절로 간다. 250 이하면 count → 본문 직접 scan + 본문 target 검증(수동 link 포함) → title 검사 → 전체 commit message 검사 순서로 네 검증을 처음부터 다시 실행한다.
- 고치기가 불가능하거나 안전하지 않으면 자동 close를 쓰지 않는다 — PR 본문의 closing 줄을 keyword만 바꿔 close를 일으키지 않는 참조로 낮추고(같은 저장소는 `Refs #<n>`, 다른 저장소는 `Refs <owner>/<repo>#<n>`, 전체 URL은 URL 그대로) safe stop해 수동 close 폴백으로 간다.
- 이슈가 **정확히 하나**만 닫히는 조건: PR 전체 commit 수 ≤ 250, `closingIssuesReferences` = 1(그 항목이 의도한 티켓), PR title의 closing keyword+이슈 참조 = 0, 모든 commit message의 closing keyword+이슈 참조 = 0. 넷을 모두 확인해야 한다. commit 수가 250을 넘으면 마지막 조건을 확인할 방법이 없으므로 자동 close 자격 자체가 없다 — 250 초과는 완전 검증이 불가능하므로 수동 close 폴백 자격도 없다(아래 `250 초과 hard stop` 절 참고).
**폴백.** **commit 수 ≤ 250일 때만** 적용한다. commit 수가 250을 넘으면 아래 `250 초과 hard stop` 절로 간다. 폴백에서는 자동 close를 쓰지 않고, landing proof + 정확한 미리보기 + 별도 승인으로 수동 close한다:

- base가 default branch가 아니거나 게시 뒤 retarget되었다.
- PR이 merge 없이 close되었다 — 자동 close는 일어나지 않고 이슈는 열려 있다.
- closing 대상이 될 티켓이 정확히 하나가 아니다(0개, 여러 개, 또는 부모 이슈뿐).
- 검증 명령이 기대와 다른 목록을 낸다.
- PR title이나 PR의 commit message에 closing keyword가 남아 있고 안전하게 고칠 수 없다.
- `closingIssuesReferences`의 여분 항목이 UI Development 패널의 수동 link인데 UI에서 unlink할 수 없다.
- 제거나 낮춤 뒤에는 `gh api 'repos/{owner}/{repo}/pulls/<PR>' --jq .commits`로 commit 수를 **가장 먼저** 다시 확인한다 — 250을 넘으면 (4)를 확인할 방법이 없어 이 zero proof가 성립하지 않으므로 아래 `250 초과 hard stop` 절로 간다. 250 이하면 (1) 본문 직접 scan(`gh pr view <PR> --json body --jq .body`)의 closing keyword+이슈 참조 = 0, (2) `closingIssuesReferences` = 0(본문 link와 UI Development 패널 수동 link 모두 0), (3) PR title의 closing keyword+이슈 참조 = 0, (4) 모든 commit message의 closing keyword+이슈 참조 = 0 — count 확인 뒤 이 순서로 넷을 모두 확인하고 전부 0일 때만 수동 close 폴백으로 간다.

수동 close는 대상 이슈가 있는 저장소를 명시한 명령으로 실행한다 — 다른 저장소 티켓이면 `gh issue close <number> -R <owner>/<repo> --comment "..."`. `-R`을 빼면 `gh`가 현재 클론의 remote에서 저장소를 추론해 이 저장소의 같은 번호 이슈를 닫는다. 같은 저장소면 `-R`이 없어도 되고 붙여도 결과가 같다. 대상은 낮춘 `Refs` 줄에 보존된 참조에서 그대로 읽는다 — 그래서 downgrade가 `<owner>/<repo>` 부분을 지우면 안 된다.

**`250 초과` hard stop.** PR의 전체 commit 수가 250을 넘으면 완전 검증이 불가능하므로 native 자동 close와 manual fallback 모두 진행하지 않는다:

1. 제거할 수 있는 잔여물을 최대한 제거한다 — PR 본문의 closing 줄은 keyword만 바꿔 낮추고(같은 저장소는 `Refs #<n>`, 다른 저장소는 `Refs <owner>/<repo>#<n>`, 전체 URL은 URL 그대로), UI Development 패널의 수동 link는 UI에서 unlink한다.
2. 제거할 수 있는 만큼 제거한 뒤 직접 확인할 수 있는 두 검증으로 남은 잔여물을 다시 scan하고 기록한다: 본문 직접 scan의 closing keyword+이슈 참조와 `closingIssuesReferences`. UI에서 unlink할 수 없는 Development 패널 수동 link는 남을 수 있다 — 이 단계는 0을 요구하는 게 아니라 남은 상태를 기록하는 것이며, 잔여물이 남아 있어도 hard stop은 진행된다. commit message 자체가 여전히 검증되지 않았으므로 어느 쪽 결과든 다음 단계로 간다.
3. 그다음 merge handoff를 **hard stop**한다 — PR을 완료로 반환하지 않고, merge를 요청하지 않으며, fallback 완료로 표시하지 않는다.
4. history를 squash / rewrite / split해 PR의 전체 commit 수를 250 이하로 만든 뒤 `--force-with-lease`로 push한다.
5. review와 이 문서의 모든 검증을 count 확인(`gh api 'repos/{owner}/{repo}/pulls/<PR>' --jq .commits`) → 본문 직접 scan + 본문 target 검증(수동 link 포함) → title 검사 → 전체 commit message 검사 순서로 처음부터 다시 실행한다. commit 수 확인이 맨 앞이다 — squash / rewrite가 오히려 수를 늘렸거나 여전히 250을 넘으면 전체 commit message 검사로 가지 않고 4단계로 돌아간다. 전부 통과하기 전에는 반환하거나 merge하지 않는다.

closing 대상을 되돌리는 방법은 출처에 따라 다르다. PR 본문 keyword에서 의도를 먼저 가른다. closing 대상 자체를 제거하려면 본문을 편집해 그 줄을 통째로 지운다. target 자동 close만 막고 참조는 폴백 / hard stop / 수동 close에서 유지하려면 keyword만 `Closes` 계열에서 `Refs`로 바꾸고 이슈 참조는 그대로 둔다 — 같은 저장소는 `Refs #<n>`, 다른 저장소는 `Refs <owner>/<repo>#<n>`, 전체 URL은 URL 그대로. 수동 close는 이 줄에 보존된 참조에서 대상 저장소와 번호를 읽으므로, 유지하는 참조를 지우면 어느 저장소의 어느 이슈였는지 알 수 없게 된다. UI Development 패널의 수동 link는 UI에서 unlink한다 — 본문 편집이나 `gh pr edit --body`로는 지워지지 않는다.

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
