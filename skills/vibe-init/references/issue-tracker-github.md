# Issue Tracker: GitHub

Issues and PRDs in this repository are managed as GitHub Issues. Use the `gh` CLI for all operations.

## Rules

- **Create Issue**: `gh issue create --title "..." --body "..."`. Use heredocs for multi-line bodies.
- **Read Issue**: `gh issue view <number> --comments`, filtering comments with `jq` and fetching labels alongside.
- **List Issues**: `gh issue list --state open --json number,title,body,labels,blockedBy,subIssues --jq '[.[] | {number, title, body, labels: [.labels[].name], blockedBy, subIssues}]'`, applying appropriate `--label` and `--state` filters. Do not request `comments` here — read comments with `gh issue view <number> --comments`.
- **Comment on Issue**: `gh issue comment <number> --body "..."`
- **Apply / Remove Labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Repository is inferred from `git remote -v` — running `gh` inside a clone handles this automatically.

## Pull Requests as Triage Surface

**PRs as request surface: no.** _(Set to `yes` if this repository treats external PRs as feature requests. The triage stage of `vibe-plan` reads this flag.)_

When set to `yes`, PRs share labels and statuses with issues, using equivalent `gh pr` commands:

- **Read PR**: `gh pr view <number> --comments` and `gh pr diff <number>` for diffs.
- **List External PRs for Triage**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`, retaining only those where `authorAssociation` is `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, or `NONE` (filtering out `OWNER`/`MEMBER`/`COLLABORATOR`).
- **Comment / Label / Close**: `gh pr comment`, `gh pr edit --add-label`/`--remove-label`, `gh pr close`.

Because GitHub shares number space between issues and PRs, a bare `#42` may refer to either — check with `gh pr view 42` and fall back to `gh issue view 42` if that fails.

## When a Skill Says "Post to Issue Tracker"

Create a GitHub Issue.

## When a Skill Says "Fetch Relevant Tickets"

Run `gh issue view <number> --comments`.

## Wayfinding Operations

Used by `/vibe-deep-plan`. A **map** is a single issue with tickets as **sub-issues**.

- **Map**: Single issue labeled `상태:초안` with Notes / Decisions-so-far / Fog body: `gh issue create --label "상태:초안"`.
- **Child Tickets**: Issues linked to map as GitHub sub-issues (using `gh api` sub-issues endpoint). Where sub-issues are not enabled, add children to task lists in map body and put `Part of #<map>` at top of child body. Labels: `유형:조사` / `유형:프로토타입` / `유형:인터뷰` / `유형:작업`. Assign to the acting developer upon claiming.
- **Blocking**: GitHub's **native issue dependencies** — canonical UI-rendered representation. Add edges via `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`, where `<blocker-db-id>` is the numeric **database id** of the blocking issue (`gh api repos/<owner>/<repo>/issues/<n> --jq .id`, not `#number` or `node_id`). Open blockers appear on `gh issue list --json blockedBy` as `blockedBy` (`totalCount` / `nodes`). Do not read `issue_dependencies_summary` from list output. If `blockedBy` or native dependencies are unavailable, fall back to `Blocked by: #<n>, #<n>` lines at top of child body. A ticket unblocks when all blocking issues close.
- **Frontier Query**: Fetch open children of the map (`gh issue list --state open --json number,title,labels,blockedBy,assignees,subIssues`, restricted to map sub-issues / task list), excluding those with open blockers (`blockedBy.totalCount > 0` or nonempty `blockedBy.nodes`, or open issues in a `Blocked by` line) or assignees, ordered by map position.
- **Claim**: `gh issue edit <n> --add-assignee @me` — first record of session.
- **Release Research Claim**: After saving full findings and research record pointer during charting, run `gh issue edit <n> --remove-assignee @me`. Leave research issue open without adding map gist. Retain assignee if save fails or session passes incomplete work.
- **Resolve**: `gh issue comment <n> --body "<answer>"`, then `gh issue close <n>`, and append context pointer (gist + link) to map's Decisions-so-far.

## Research Record Persistence

- Calling session posts full findings with source citations in a single dedicated comment on the same research issue, starting with `<!-- vibe-deep-plan research: <map-issue>/<ticket-issue> -->` for immutable identity lookup.
- If comments exceed GitHub limits, use ordered comments (`Research record 1/N`, `2/N`...) or repo-owned wikis, snippets, attachments, or equivalent persistent artifacts, linking that record from the issue comment. Never truncate findings or leave only in local files.
- Record `Research record: <comment or artifact URL>` on ticket. Hosted research has no `Branch`, `Commit`, or `Path` pointers, and never creates or pushes `research/...` branches.
- Keep research issues open during charting without map gists. Release claim after successful save with `gh issue edit <n> --remove-assignee @me`. Retain claim if save fails. Inspect existing comments and linked artifacts before re-running.
