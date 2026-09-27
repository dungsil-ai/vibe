# Configuration Documents and Defaults

Initialization is not a prerequisite when the skill configuration block in `AGENTS.md` or configuration documents under `docs/agents/` are absent. Proceed directly with **local Markdown** unless existing configuration or the user specifies another tracker. A GitHub or GitLab remote alone does not select a hosted tracker.

## Resolve Configuration

- Prioritize user instructions and already-recorded tracker, path, label, and domain-document settings. When only some files are missing, preserve existing settings and use the defaults below only for missing items.
- If `docs/agents/issue-tracker.md` is absent and there is no other explicit choice, read the [local tracker rules](issue-tracker-local.md). Store specs at `.agents/plans/<feature>/spec.md` and implementation tickets under `issues/<NN>-<slug>.md` in the same directory. Follow that reference's paths and status rules for decision maps and typed records as well.
- If `docs/agents/triage-labels.md` is absent, read the [default role mapping](triage-labels.md). Represent roles in the relevant Markdown records for local work; do not create remote labels. Preserve existing Korean strings and the `Type:`/`Status:` contracts.
- If `docs/agents/domain.md` is absent, read the [default domain-document rules](domain.md). Use existing `CONTEXT.md`, `CONTEXT-MAP.md`, and relevant ADRs; if those are also absent, do not require creating them in advance.

Use the same substitute documents when later skill instructions refer to these configuration paths. Read bundled references in place; do not copy them into the project. If a hosted tracker is explicitly selected, do not switch to local: use the [GitHub](issue-tracker-github.md) or [GitLab](issue-tracker-gitlab.md) reference and the provided repository information. For another tracker, ask only for missing information needed by that workflow, not for full initialization.

## Authority and Artifacts

Explicit `plan`, `review-plan`, or `reconcile` requests and execution-plan handoffs for selected audit or direction findings follow `/vibe-plan`'s [execution-plan contract](../../vibe-plan/EXECUTION-PLAN.md). That path keeps the local plan authoritative and handles GitHub publication under its contract only with `--issues`. It does not change existing tracker settings for ordinary specs and tickets. Resolve any conflict between existing configuration and the publication target first.

Never invoke or require `/vibe-init` merely because configuration is absent. Applying defaults does not create `AGENTS.md`, configuration files under `docs/agents/`, or initialization-only commits or pushes. Run `/vibe-init` only when the user requests creating or changing configuration.

Local defaults grant no additional write authority. Planning skills create planning files within the requested scope; implementation skills update tickets under their existing completion contract. Review only reads existing local specs and tickets. Missing configuration does not authorize moving existing artifacts or creating remote issues or PR/MRs.
