---
name: vibe-implement
description: Implements tasks from a spec or ticket collection. Approaches implementation test-first at pre-agreed boundaries, followed by review and commit. Use when the user requests implementation, build, or delivery of an already-agreed spec, ticket, or plan.
disable-model-invocation: true
---

# Task Implementation

Implement work specified by the user in a spec or ticket.

## Planning Boundary

This skill never performs planning-family activities. It does not perform triage, exploration, spec drafting/editing, decomposition, ticket creation/splitting, ticket publishing, or plan modification. Implementation begins only from an already-agreed spec or ticket.

If input requires planning, or if the plan is incorrect or the spec is insufficient, stop implementation and return work to the caller or `/vibe-plan`/`/vibe-deep-plan`. Do not fix or alter plans inside this skill.

## Completion Ownership

Establish and record exactly one mode upon invocation:

- **Caller-supplied** — Caller (e.g. `/vibe-goal`) provides and owns ticket-specific assigned work branches and worktrees, and also owns integration and final landing. The lifecycle of implementation → review → finding fixes → resumption for the same ticket reuses that exact single assigned workspace. Never add a second workspace for the same ticket.
- **Standalone** — Direct `/vibe-implement` workflow. For version-controlled local Markdown trackers, owns branch maintenance, publishing, and in-commit ticket updates as directed by the tracker. For hosted trackers, ticks acceptance checkboxes after a clean review and before the human merges; proposes issue close only in follow-up or resumption after independent landing proof. Never owns final landing.

If completion mode is unclear, stop and ask before creating or altering workspaces.

Before touching anything, locate existing **workspace records** for the same logical task. Implementation, review, review-fix, and resuming prior runs are all the same task. Workspace records bind the task unit ID to original target/ref, fixed point, branch, worktree path, and current owner/status. This resides in the caller or handoff record providing the workspace (caller-supplied) or the run's own prior return record (standalone). If exactly one matching record exists with no other active owner, reuse as-is. Continue all work in the existing worktree; if the worktree was removed, reattach to the preserved branch (do not create a newly numbered branch), preserve the original fixed point (do not recompute from current HEAD), and create no new branch or worktree. If records are missing, multiple candidates exist, other active owners exist, or unexpected head/unsafe dirty states occur, stop and report. Do not guess by branch name, number, slug, or latest `vibe/*`, and do not create new siblings. Only for new logical tasks with no matching record do you capture the current commit (`git rev-parse HEAD`) as the **fixed point** for review, create a single workspace according to Workspace Isolation below, and record it in return results.

## Workspace Isolation

Before classifying change size, apply the record lookup from Completion Ownership first. If matched to an existing workspace record for the same logical task, continue all implementation, testing, review-fixes, and resumption in that exact workspace (existing worktree or reattached to preserved branch) regardless of change size (including one-line review fixes or resumptions) and skip to Linearity Rules below. Never send such continuations to the original checkout. In caller-supplied mode, use only the caller-provided ticket-assigned branch and worktree identified by caller records. Never use integration branches. Never add a second workspace for implementation, review, finding fixes, or retries of the same ticket, regardless of how small the change is. Missing or ambiguous caller-supplied records are stop-and-report conditions, not permissions to create new workspaces. If no matching record exists in Standalone mode, classify the requested change. Single-file changes or other trivial edits fall below the isolation threshold and proceed in-place without creating a dedicated worktree. For larger changes with no matching record in Standalone mode, if the project uses git with at least one commit (`git rev-parse HEAD` succeeds) and this is a new logical task, isolate work in a dedicated worktree instead of editing the original checkout:

1. Name the branch `vibe/{number}-{function}`. `{number}` is the next sequential integer among existing `vibe/*` branches (starting from 1), and `{function}` is a short kebab-case slug for the feature (e.g. `vibe/3-user-auth`).
2. Create: `git worktree add .agents/worktrees/{number}-{function} -b vibe/{number}-{function}` (branched at fixed point). Ensure `.agents/worktrees/` is git-ignored.
3. Perform all implementation, testing, and review within that worktree.

Maintain the work branch as the implementation source without modifying the original branch. The same logical task (initial implementation, review-fixes, all resumptions) reuses the single workspace identified by records without creating a second branch or worktree. Continuing runs do not create new `vibe/{next-number}-*` branches for the same task. Execution creates at most one branch and at most one worktree, maintaining linear history on that branch. Never merge original branch, integration branch, or target into the work branch. If the base moves, rebase the work branch onto it in standalone mode; in caller-supplied mode, report the moved base to the caller instead of merging or rebasing directly. Caller-supplied runs operate only on supplied work branches and worktrees. Do not create extra branches or worktrees, modify original target checkouts, publish or merge work branches, or clean, delete, or alter caller-supplied worktrees after return. After reviewed work is committed, follow Completion Disposition below. Do not merge automatically. Record workspace details (task unit ID, original target/ref, fixed point, branch, worktree path, owner/status) in completion returns so subsequent review-fixes or resumptions for the same logical task reuse it precisely instead of creating new workspaces.

If the repository has no commits yet (or project is not a git repo), skip isolation and work in-place.

Implement test-first at pre-agreed boundaries. Follow [TDD.md](TDD.md): red → green loops, boundary rules, anti-patterns to avoid.

Reference documents to read as needed:

- [TDD.md](TDD.md) — Red → green loop and rules
- [tests.md](tests.md) — What good tests look like, with examples
- [mocking.md](mocking.md) — When to mock, what to mock instead
- [MERGE-CONFLICTS.md](MERGE-CONFLICTS.md) — Resolving in-progress merge or rebase conflicts

Run type checks regularly, individual test files regularly, and full test suites once at the end.

## Commit Signing

Because commits in this workflow are authored by an AI and not a human, they must not be signed as though made by a human. Never pass `-S`, `--gpg-sign`, or `--signoff` to `git commit`. If repository or global configuration enables signing by default (`commit.gpgsign = true`), override per commit with `git -c commit.gpgsign=false commit ...` so results are honestly unsigned. This applies to every commit created by this workflow, including checkbox flip edits bundled into implementation commits.

## Completion Disposition

1. Read `docs/agents/issue-tracker.md`.
2. On the work branch, run `/vibe-review` against the fixed point recorded at startup, passing implemented spec or tickets so each enabled review axis has its required source. Follow `/vibe-review`'s risk-request and high-risk-change rules for enabling Risk; this skill defines no separate condition. Do not ask the user for fixed points; they are already known. `/vibe-review` is read-only: it reports findings but never modifies issue bodies, checkboxes, comments, labels, or statuses. Passing reviews never authorize closing issues.
3. If read-only review has no unresolved findings, commit reviewed work to the work branch. Acceptance checkbox flips ([Tracker Updates](#tracker-updates)) are part of this disposition and finish before the human merges. Then follow the mode recorded upon invocation:
   - **Caller-supplied.** Commit directly to caller-supplied work branch, keeping linear above caller-supplied base. Do not create extra branches or worktrees. Do not publish work branches, treat them as durable artifacts, or clean them up directly. Do not merge or land into original target. Do not clean, delete, or alter caller-supplied worktrees. Caller owns and disposes of them. On hosted trackers, tick acceptance checkboxes only per [Tracker Updates](#tracker-updates); do not close issues or change close-status. Version-controlled local Markdown ticket files are branch content included in ticket commits per [Tracker Updates](#tracker-updates). Return branch name, exact supplied ticket base SHA, exact reviewed head SHA, verification proof, read-only `/vibe-review` verdict and report, notes on whether supplied base moved, and a one-line resumption record (task unit ID, work branch, worktree path, current owner/status). This enables subsequent review-fixes or retries for the same ticket to reuse this exact workspace instead of creating new branches or worktrees. Nothing else. Caller owns integration and final landing.
   - **Standalone.** Finish with exactly one surviving branch and no leftover worktree: reviewed `vibe/*` branch, linear on fixed point. If target moved, rebase onto it without merge commits. Maintain that branch as implementation source instead of landing. For local Markdown trackers, confirm unmerged branch is preserved before removing worktree and report branch name. For GitHub, push work branch and create a pull request targeting the original branch. For GitLab, push and create a merge request targeting the original branch. On hosted trackers, tick acceptance checkboxes before publishing per [Tracker Updates](#tracker-updates); do not close the issue; do not merge automatically. For other hosted trackers supporting pull/merge requests, follow documented publishing workflows. Remove worktree only after preservation or publishing succeeds. Report preserved branch name (or request URL for hosted trackers) and a one-line resumption record (task unit ID, original target/ref, fixed point, preserved branch, empty worktree path once removed, current owner/status). This enables subsequent review-fixes or resumptions to reattach worktrees to that exact preserved branch instead of creating new `vibe/*` branches. Leave no other `vibe/*` branches or worktrees from the same run. Do not merge automatically. Original branch remains untouched.

If unrelated dirty states, conflict ambiguities, or other unsafe conditions prevent safe disposition, do not publish, merge, clean up, or delete. Preserve original and resulting branches and commits, leave user state untouched, and report blockers. Branch or worktree removal is permitted only after disposition is safe. For in-progress merge or rebase conflicts, follow [MERGE-CONFLICTS.md](MERGE-CONFLICTS.md).

## Tracker Updates

- **Local Markdown, Version-Controlled.** Ticket files are branch content, not external systems. Inside the work branch worktree, flip acceptance checkboxes to `[X]` and include that edit in the same commit as the implementation. No separate tracker commits, comments, or commits on original/target branches. Do not await landing proof or request tracker-change approval. User owns merge; merge carries code and checklist together or neither. Do not edit `Status:` lines.
- **Hosted Trackers (GitHub, GitLab, other hosted trackers).** Acceptance checklists and issue close are separate. The human owns merge; the agent never merges. Publishing is not landing.
  - **Checklist.** If read-only review has no unresolved findings, tick the ticket's acceptance checkboxes before publishing the PR/MR (standalone) or returning to the caller (caller-supplied). Do not await landing proof or request checkbox-only approval. Do not close the issue.
  - **Close/status.** Closing an issue is not the merge gate. Only after independently obtaining authoritative proof that the exact reviewed commit SHA is on the designated target branch (e.g. `git merge-base --is-ancestor <commit> <target-branch>` succeeds) may follow-up or resumption standalone actions show an exact preview of close, status, and comments. Await separate explicit approval immediately before writing. Implementation requests, completed reviews, declines, or non-responses do not constitute close approval. Never close issues without approval.

Never propose or modify parent spec issues on any tracker.
