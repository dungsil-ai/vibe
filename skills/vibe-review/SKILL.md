---
name: vibe-review
description: Reviews changes after a fixed point (commit, branch, tag, or merge-base) along two axes — Standards (does code follow repository coding standards?) and Spec (does code match source issue/PRD requirements?) — running two axes in parallel subagents and reporting side by side. Use when reviewing branches, PRs, or working changes, or when asked to "review after X".
---

# Reviewing Changes

A two-axis review of the diff between `HEAD` and a user-provided fixed point:

- **Standards** — Does the code adhere to this repository's documented coding standards?
- **Spec** — Does the code faithfully implement the source issue / PRD / spec?

The two axes run as **parallel subagents** so they do not pollute each other's context, with this skill aggregating the findings.

The Spec axis is a **fast review** — a single subagent reading the diff against the spec and reporting missing requirements, scope creep, and incorrect implementations within 400 words. When a formal verdict is needed — acceptance criteria with per-item status, separated evidence domains (`CODE` vs `OPERATION` vs `DATA`), independent reviewer passes, aggregate `PASS`/`FAIL`/`NEEDS_REVIEW` — run `/rq` on the same requirements. Use that when changes are high-risk (security, auth, permissions, persistence, transactions, integration), when the user asks whether requirements are genuinely *satisfied* rather than what is missing, or when findings demand a verdict rather than an enumeration. It replaces this axis; do not run both and merge them.

Issue tracker should have been provided — run `/vibe-init` if `docs/agents/issue-tracker.md` is missing.

## Process

### 1. Pin the Fixed Point

What the user specified as fixed point — commit SHA, branch name, tag, `main`, `HEAD~5`, etc. If another skill invoked this skill passing a fixed point (`/vibe-implement` passes its commit recorded prior to start), use it without asking. Ask only when neither user nor caller provided one.

Capture diff command once: `git diff <fixed-point>...HEAD` (three dots for merge-base comparison). Record commit list via `git log <fixed-point>..HEAD --oneline`.

Verify fixed point resolves (`git rev-parse <fixed-point>`) and diff is non-empty before proceeding. Invalid refs or empty diffs must fail here — not inside two parallel subagents.

### 2. Identify Spec Source

Locate source spec in this order:

1. Issue references in commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.) — fetch via `docs/agents/issue-tracker.md` workflow.
2. Paths passed by user as arguments.
3. PRD/spec files under `docs/`, `specs/`, or `.agents/plans/` matching branch name or feature.
4. If none found, ask user for spec location. If user states there is none, skip **Spec** subagent and report "No spec".

### 3. Identify Standards Source

Anything documenting how code should be written in this repository, such as `CODING_STANDARDS.md` or `CONTRIBUTING.md`.

On top of repository documentation, the Standards axis always includes the **Smell Baseline** below — a fixed set of Fowler code smells (*Refactoring*, ch.3) applying even when repos document nothing. Two rules bind this:

- **Repository takes precedence.** Documented repo standards always win; if repo endorses what the baseline flags, suppress the smell.
- **Always judgment calls.** Each smell is a labeled heuristic ("possible Feature Envy"), never a hard violation — and, like all standards here, skip what tooling already enforces.

Read each smell as *What it is* → *How to fix*; tailored to diffs:

- **Mysterious Name** — Function, variable, or type names failing to reveal what they do or hold. → Rename; if no honest name comes to mind, design is unclear.
- **Duplicated Code** — Same logical shape appears across multiple hunks or files in the change. → Extract shared shape and call from both sides.
- **Feature Envy** — Reaching into another object's data more than its own. → Move method to the data it envies.
- **Data Clumps** — Same few fields or parameters traveling together repeatedly (types waiting to be born). → Bundle into a single type and pass that.
- **Primitive Obsession** — Primitives or strings substituting for domain concepts deserving own types. → Give the concept a small type of its own.
- **Repeated Switches** — Same `switch`/`if` ladder over same types repeating across the change. → Replace with polymorphism or a shared map.
- **Shotgun Surgery** — Single logical change forcing edits scattered across multiple files in the diff. → Consolidate co-changing code into one module.
- **Divergent Change** — Single file or module edited for multiple unrelated reasons. → Split so each module changes for one reason.
- **Speculative Generality** — Abstractions, parameters, or hooks for needs absent from the spec. → Delete; revert inline until real need appears.
- **Message Chains** — Long `a.b().c().d()` navigations callers should not depend on. → Hide path behind a single method on first object.
- **Middle Man** — Classes or functions mostly delegating. → Cut them and call the real target directly.
- **Refused Bequest** — Subclasses or implementations ignoring or overriding most inherited behavior. → Abandon inheritance and use composition.

### 4. Run Two Subagents in Parallel

Dispatch two `Agent` tool calls in a single message, both using `general-purpose` subagents.

**Standards Subagent Prompt** — Include:

- Full diff command and commit list.
- List of standards source files found in Step 3, **plus the full Smell Baseline from Step 3** pasted in — subagents have no other access.
- Instructions: "Report — per relevant file/hunk — (a) where diff violates documented standards: cite standard (file + rule); and (b) noticeable baseline smells: name smell and cite hunk. Distinguish hard violations from judgment calls — documented standard violations may be hard, baseline smells are always judgment calls, and documented repo standards override baseline. Skip what tooling enforces. Under 400 words."

**Spec Subagent Prompt** — Include:

- Diff command and commit list.
- Spec path or fetched contents.
- Instructions: "Report: (a) requirements required by spec but missing or partial; (b) unrequested behavior in diff (scope creep); (c) requirements appearing implemented but implemented incorrectly. Cite spec lines for each finding. Under 400 words."

If spec is absent, skip Spec subagent and note this in final report.

### 5. Aggregate

Present both reports under `## Standards` and `## Spec` headers, as-is or lightly trimmed. Do **not** merge or re-rank findings — the two axes are intentionally separated (see *Why Two Axes*).

Conclude with a one-line summary: total findings per axis, and worst issue *within each axis* (if any). Do not pick a single winner between axes — that is the re-ranking separation seeks to avoid.

### 6. Read-Only Review Contract

Direct reviews and reviews invoked by other workflows are **read-only**. The sole output is the separated Standards and Spec report in Step 5:

- On clean passes, report 0 findings; passes are not authority to land, update, or close work.
- If findings exist, report findings; if spec was absent, report that limitation.
- Never edit issue/PR bodies or acceptance boxes, post comments, alter labels/statuses, close/reopen work, or create other tracker, repository, or external side effects.

Subsequent persistent actions belong to execution workflows following specific execution requests and explicit approvals immediately before action. Declines or non-responses leave tracker state unchanged.

## Why Two Axes

Changes can pass one axis and fail the other:

- Code following all standards but implementing the wrong feature → **Standards Pass, Spec Fail.**
- Code doing exactly what the issue requested but violating project conventions → **Spec Pass, Standards Fail.**

Reporting separately prevents one axis from obscuring the other.
