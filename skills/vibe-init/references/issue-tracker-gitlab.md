# Issue Tracker: GitLab

Issues and PRDs in this repository are managed as GitLab Issues. Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI for all operations.

## Rules

- **Create Issue**: `glab issue create --title "..." --description "..."`. Use heredocs for multi-line descriptions. Passing `--description -` opens an editor.
- **Read Issue**: `glab issue view <number> --comments`. Use `-F json` for machine-readable output.
- **List Issues**: `glab issue list -F json`, applying appropriate `--label` filters.
- **Comment on Issue**: `glab issue note <number> --message "..."`. GitLab calls comments "notes".
- **Apply / Remove Labels**: `glab issue update <number> --label "..."` / `--unlabel "..."`. Separate multiple labels with commas or repeat flags.
- **Close**: `glab issue close <number>`. `glab issue close` does not accept closing comments, so post notes first via `glab issue note <number> --message "..."` before closing.
- **Merge Requests**: GitLab calls PRs "merge requests". Use `glab mr create`, `glab mr view`, `glab mr note`, etc. — identical to `gh pr ...` patterns substituting `mr` for `pr` and `note`/`--message` for `comment`/`--body`.

Repository is inferred from `git remote -v` — running `glab` inside a clone handles this automatically.

## Merge Requests as Triage Surface

**MRs as request surface: no.** _(Set to `yes` if this repository treats external merge requests as feature requests. The triage stage of `vibe-plan` reads this flag.)_

When set to `yes`, MRs share labels and statuses with issues, using equivalent `glab mr` commands:

- **Read MR**: `glab mr view <number> --comments` and `glab mr diff <number>` for diffs.
- **List External MRs for Triage**: `glab mr list -F json`, retaining only MRs where authors are not project members/owners (contributor MRs rather than maintainer in-progress work).
- **Comment / Label / Close**: `glab mr note`, `glab mr update --label`/`--unlabel`, `glab mr close`.

Unlike GitHub, GitLab numbers issues and MRs separately, so `#42` is unambiguous once the maintainer knows the surface.

## When a Skill Says "Post to Issue Tracker"

Create a GitLab Issue.

## When a Skill Says "Fetch Relevant Tickets"

Run `glab issue view <number> --comments`.

## Wayfinding Operations

Used by `/vibe-deep-plan`. A **map** is a single issue with tickets as **sub-issues**.

- **Map**: Single issue labeled `상태:초안` with Notes / Decisions-so-far / Fog body: `glab issue create --label "상태:초안"`. (In GitLab tiers with native Epics, Epics can replace maps. Labeled issues work anywhere.)
- **Child Tickets**: Issues with `Part of #<map>` at top of description, labeled `유형:조사` / `유형:프로토타입` / `유형:인터뷰` / `유형:작업`. Assign to the acting developer upon claiming.
- **Blocking**: Add via the links API — `glab api --method POST "projects/:id/issues/<child>/links" -F target_project_id=<id> -F target_issue_iid=<blocker> -F link_type=is_blocked_by`. **Do not use quick actions**: `/blocked_by` is unrecognized on tiers without native blocking and posts as a literal comment. If that call returns `HTTP 400 link_type does not have a valid value`, the instance has no native blocking (Free/CE) — record blockers as a `#<n>` list in the description's "Prerequisites" section only. A ticket unblocks when all blocking issues close.
- **Frontier Query**: Fetch `glab issue list -F json` restricted to map children, excluding those with open blockers (native `is_blocked_by` links to open issues via `glab api projects/:id/issues/:iid/links` or open issues in the "Prerequisites" section) or assignees, ordered by map position.
- **Claim**: `glab issue update <n> --assignee @me` — first record of session.
- **Release Research Claim**: After saving full findings and research record pointer during charting, run `glab issue update <n> --assignee=-@me` (replacing `@me` with actual session username if needed). Leave research issue open without adding map gist. Retain assignee if save fails or session passes incomplete work.
- **Resolve**: `glab issue note <n> --message "<answer>"`, then `glab issue close <n>`, and append context pointer (gist + link) to map's Decisions-so-far.

## Research Record Persistence

- Calling session posts full findings with source citations in a single dedicated note on the same research issue, starting with `<!-- vibe-deep-plan research: <map-issue>/<ticket-issue> -->` for immutable identity lookup.
- If notes exceed provider limits, use ordered notes (`Research record 1/N`, `2/N`...) or project wikis, snippets, attachments, or equivalent persistent artifacts, linking that record from the issue note. Never truncate findings or leave only in local files.
- Record `Research record: <note or artifact URL>` on ticket. Hosted research has no `Branch`, `Commit`, or `Path` pointers, and never creates or pushes `research/...` branches.
- Keep research issues open during charting without map gists. Release claim after successful save with `glab issue update <n> --assignee=-@me` (replacing `@me` with actual username if needed). Retain claim if save fails. Inspect existing notes and linked artifacts before re-running.
