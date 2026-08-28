---
name: vibe-init
description: 이 저장소를 vibe-coding 스킬에 맞게 설정한다 — 이슈 트래커, 트리아지 라벨 어휘, 도메인 문서 구조를 AGENTS.md에 기록한다. 다른 vibe-coding 스킬을 처음 쓰기 전에 한 번 실행하거나, 사용자가 이슈 트래커를 바꾸거나 트리아지 상태 라벨을 다시 지정하거나 docs/agents/issue-tracker.md가 없는 이유를 물을 때 쓴다.
disable-model-invocation: true
---

# 바이브 초기화

**한국어 저장소 글:** 이 스킬이 한국어 문서, 커밋 메시지, 이슈, PR, 리뷰 또는 댓글을 작성하거나 다듬을 때에는 저장하거나 전송하기 전에 `/vibe-docs`를 적용한다. `/vibe-docs`는 표현만 다루며, 이 스킬의 권한이나 외부 변경 범위를 넓히지 않는다.

엔지니어링 스킬이 전제하는 저장소별 설정을 스캐폴드한다:

- **이슈 트래커** — 이슈가 사는 곳(기본 GitHub. 로컬 마크다운도 즉시 지원)
- **트리아지 라벨** — 다섯 정규 트리아지 역할에 쓰는 문자열(기본 한국어)
- **도메인 문서** — `CONTEXT.md`와 ADR이 사는 곳, 그리고 읽는 규칙

모든 설정은 `AGENTS.md`에만 기록된다. 이 스킬은 `CLAUDE.md`나 다른 에이전트 지시 파일을 읽거나 쓰지 않는다 — 그런 파일이 있어도 마찬가지다.

이것은 프롬프트 구동 스킬이지 결정적 스크립트가 아니다. 탐색하고, 발견한 것을 제시하고, 사용자와 확인한 뒤, 기록한다.

## 과정

### 1. 탐색

현재 저장소를 살펴 출발 상태를 파악한다. 있는 것을 읽는다. 가정하지 않는다:

- `git remote -v`와 `.git/config` — GitHub 저장소인가? 어느 저장소인가?
- `git status --short` — 이 실행 전에 이미 있던 변경은 무엇인가? 나중에 이 스킬의 변경과 섞지 않도록 정확한 경로를 기록한다.
- 현재 브랜치와 upstream의 차이 — 원격 트래커를 사용할 때 어느 브랜치를 push해야 하는가? 이 실행 전에 이미 push되지 않은 commit이 있는가?
- 저장소 루트의 `AGENTS.md` — 있는가? 이미 `## Agent skills` 섹션이 있는가?
- 저장소 루트의 `CONTEXT.md`와 `CONTEXT-MAP.md`
- `docs/adr/`과 `src/*/docs/adr/` 디렉터리
- `docs/agents/` — 이 스킬의 이전 출력이 이미 있는가?
- `.agents/plans/` — 로컬 마크다운 이슈 트래커 관행이 이미 쓰이고 있다는 신호
- `docs/agents/out-of-scope/`(또는 기존 `.agents/out-of-scope/`) — 거부된 요청 지식베이스가 이미 쓰이고 있다는 신호
- `vibe-plan` / `vibe-deep-plan`이 설치되어 있는가? (이 스킬 폴더 옆의 스킬 폴더, 또는 사용 가능 스킬 목록의 이름). 이들은 라벨 어휘를 소비한다 — 둘 다 계획 유형을, `vibe-plan`은 트리아지 상태를, `vibe-deep-plan`은 지도 상태와 결정 유형을 쓴다 — 그러므로 이것이 B절이 실행될지를 결정한다.
- 모노레포 신호 — `pnpm-workspace.yaml`, `package.json`의 `workspaces` 필드, 또는 자체 `src/`를 가진 채워진 `packages/*`. 진짜로 큰 다중 패키지 저장소에서만 제시한다. 없으면 단일 컨텍스트이며, 이는 거의 모든 저장소에 해당한다.

### 2. 발견한 것을 제시하고 묻기

있는 것과 빠진 것을 요약한다. 그다음 절을 순서대로 — 한 절, 한 답, 그다음 절.

각 절을 권장 답으로 시작해 사용자가 한마디로 받을 수 있게 한다. 선택이 진짜로 갈릴 때만 한 줄 설명을 붙이고, 탐색이 이미 정한 절은 건너뛴다(트리아지가 설치되지 않은 B절, 모노레포가 아닌 C절).

**A절 — 이슈 트래커.**

> 설명: "이슈 트래커"는 이 저장소의 이슈가 사는 곳이다. `vibe-plan`과 `vibe-review` 같은 스킬은 여기서 읽고 쓴다 — `gh issue create`를 호출할지, `.agents/plans/` 아래 마크다운 파일을 작성할지, 또는 사용자가 설명하는 다른 워크플로를 따를지 알아야 한다. 이 저장소에서 실제로 작업을 추적하는 곳을 고른다.

기본 태도: 이 스킬들은 GitHub에 맞춰 설계되었다. `git remote`가 GitHub을 가리키면 그것을 제안한다. `git remote`가 GitLab(`gitlab.com` 또는 자체 호스트)을 가리키면 GitLab을 제안한다. 그 밖의 경우(또는 사용자가 원하면) 다음을 제시한다:

- **GitHub** — 이슈가 저장소의 GitHub Issues에 산다(`gh` CLI 사용)
- **GitLab** — 이슈가 저장소의 GitLab Issues에 산다([`glab`](https://gitlab.com/gitlab-org/cli) CLI 사용)
- **로컬 마크다운** — 이슈가 이 저장소의 `.agents/plans/<feature>/` 아래 파일로 산다(개인 프로젝트나 리모트 없는 저장소에 적합)
- **기타**(Jira, Linear 등) — 사용자에게 워크플로를 한 단락으로 설명해 달라고 한다. 스킬이 자유 형식 글로 기록한다

선택을 `docs/agents/issue-tracker.md`에 기록한다. GitHub과 GitLab 템플릿은 "PR을 요청 표면으로" 플래그를 가지며, 기본값은 **꺼짐** — 꺼진 채로 두고 언급하지 않는다. 트리아지 대기열에 외부 PR을 원하는 사용자는 나중에 파일에서 플래그를 켤 수 있다.

**B절 — 라벨 어휘.** `vibe-plan`과 `vibe-deep-plan` 둘 다 설치되지 않았다면(탐색이 알려준다) 이 절 전체를 건너뛴다 — 라벨을 소비할 것이 없다.

둘 중 하나라도 설치되어 있으면 정확히 한 질문만 한다:

> 기본 라벨을 유지하시겠습니까? (권장: **예**)

기본값은 한국어, 축별 접두사:

- **트리아지 상태**(`vibe-plan`) — `상태:분류필요` (needs-triage), `상태:정보필요` (needs-info), `상태:에이전트작업` (ready-for-agent), `상태:사람작업` (ready-for-human), `상태:처리안함` (wontfix)
- **계획 유형**(`vibe-plan` 또는 `vibe-deep-plan`) — 호스트형 명세/계획 이슈와 결정 맵용 `유형:계획`
- **결정 지도 라벨**(`vibe-deep-plan`) — 결정 맵 상태용 `상태:초안`, 그리고 네 결정 티켓 유형용 `유형:조사` / `유형:프로토타입` / `유형:인터뷰` / `유형:작업`

설치된 스킬의 계열만 작성한다. **예**이면 그대로 작성한다. 사용자가 아니라고 할 때만 — 보통 트래커가 이미 다른 이름을 쓰기 때문(예: needs-triage를 `bug:triage`) — 중복을 만드는 대신 기존 라벨을 적용하도록 재정의를 모은다.

**C절 — 도메인 문서.** 기본은 **단일 컨텍스트** — 저장소 루트에 하나의 `CONTEXT.md` + `docs/adr/`. 거의 모든 저장소에 맞다. 묻지 않고 기록한다.

탐색이 모노레포 신호를 찾은 경우에만 **다중 컨텍스트** — 루트 `CONTEXT-MAP.md`가 컨텍스트별 `CONTEXT.md` 파일을 가리키는 — 을 제시한다. 그 다음 어느 구조를 원하는지 확인한다.

### 3. 확인하고 편집하기

사용자에게 다음의 초안을 보여준다:

- `AGENTS.md`에 추가할 `## Agent skills` 블록
- `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, `docs/agents/triage-labels.md`의 내용(마지막은 계획 스킬이 설치되어 있을 때만)

기록 전에 편집하게 한다.

### 4. 기록하기

`AGENTS.md`가 있으면 편집하고, 없으면 만든다. 절대 `CLAUDE.md`를 편집하지 않는다 — `CLAUDE.md`만 있어도 새 `AGENTS.md`를 만들고 `CLAUDE.md`는 그대로 둔다.

`AGENTS.md`에 이미 `## Agent skills` 블록이 있으면 중복을 추가하는 대신 내용을 제자리에서 갱신한다. 주변 섹션의 사용자 편집은 덮어쓰지 않는다.

**`.gitignore`** — 저장소가 git을 쓰면 에이전트 스크래치 경로가 무시되게 한다: `.gitignore`가 이미 덮지 않을 때 `.agents/worktrees/`와 `.agents/prototype/`을 덧붙인다(필요 시 파일을 만든다). **로컬 마크다운** 트래커에서는 `.agents/plans/`이 **추적**되어야 한다 — 스킬이 티켓의 체크리스트를 구현 커밋 안에 함께 커밋하며, 무시된 파일에는 불가능하다 — 그러므로 스크래치 경로만 무시한다. 광범위한 `.agents/` 항목은 뒤의 부정으로 다시 포함할 수 없으므로, `.agents/*`와 `!.agents/plans/`로 바꾼다. 다른 트래커에서는 `.agents/` 전체를 무시해도 좋다.

블록:

```markdown
## Agent skills

### Issue tracker

[이슈가 어디서 추적되는지 한 줄 요약]. `docs/agents/issue-tracker.md` 참조.

### Triage labels

[라벨 어휘 한 줄 요약]. `docs/agents/triage-labels.md` 참조.

### Domain docs

[구조 요약 — "단일 컨텍스트" 또는 "다중 컨텍스트"]. `docs/agents/domain.md` 참조.
```

계획 스킬이 설치되어 있고 B절이 실행되었을 때만 `### Triage labels` 하위 블록을 포함하고 `docs/agents/triage-labels.md`를 작성한다. 그렇지 않을 때는 둘 다 생략한다.

그다음 이 스킬 폴더의 시드 템플릿을 출발점으로 써서 문서 파일을 작성한다:

- [issue-tracker-github.md](references/issue-tracker-github.md) — GitHub 이슈 트래커
- [issue-tracker-gitlab.md](references/issue-tracker-gitlab.md) — GitLab 이슈 트래커
- [issue-tracker-local.md](references/issue-tracker-local.md) — 로컬 마크다운 이슈 트래커
- [triage-labels.md](references/triage-labels.md) — 라벨 매핑(계획 스킬이 설치되어 있을 때만)
- [domain.md](references/domain.md) — 도메인 문서 소비 규칙 + 구조

"기타" 이슈 트래커는 사용자의 설명으로 `docs/agents/issue-tracker.md`를 처음부터 작성한다.

### 5. 커밋하기

Git 저장소이고 이 실행이 파일을 바꿨으면, 다음 원격 변경이나 다음 작업으로 넘어가기 전에 이 스킬의 변경을 커밋한다.

1. `git diff`로 결과를 확인한다. 탐색 때 이미 있던 변경은 이 스킬의 변경으로 보지 않는다.
2. `git add .`이나 넓은 경로를 쓰지 않고, 이 실행에서 만든 또는 바꾼 정확한 파일만 stage한다.
3. 대상 파일에 기존 사용자 변경이 섞여 있으면, 이 실행의 hunk만 안전하게 stage할 수 있을 때만 분리한다. 안전하게 나눌 수 없으면 커밋하지 말고 충돌한 경로를 알린 뒤 사용자에게 묻는다.
4. staged diff가 이 실행의 설정 변경만 담는지 확인하고, 저장소의 기존 형식에 맞는 한 개의 커밋을 만든다.
5. commit SHA를 확인한다. 커밋이나 확인이 실패하면 멈춘다.
6. GitHub, GitLab 또는 다른 원격 트래커를 사용한다면, 라벨이나 이슈를 등록하기 전에 현재 브랜치를 일반 push하고 remote branch에 commit SHA가 반영되었는지 확인한다. force push는 하지 않는다.
7. 탐색할 때부터 push되지 않은 기존 commit이 있었다면, 이 스킬의 push가 그 commit도 함께 게시한다. 자동으로 push하지 말고 포함될 commit을 보여준 뒤 사용자에게 묻는다.

변경할 파일이 없거나 Git 저장소가 아니면 커밋을 만들지 말고 그 이유를 알린다. 필수 push나 remote SHA 확인이 실패하면 GitHub/GitLab 라벨 생성·수정이나 다른 이슈 트래커 변경을 하지 않는다.

### 6. 완료

설정이 끝났고 어느 엔지니어링 스킬이 이 파일들에서 읽게 되는지 사용자에게 알린다. 나중에 `docs/agents/*.md`를 직접 편집할 수 있다고 안내한다 — 이슈 트래커를 바꾸거나 처음부터 다시 시작할 때만 이 스킬을 다시 실행하면 된다.
