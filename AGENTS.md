# Skills Generate
Generate [Agent Skills](https://agentskills.io/home) from project documentation.

PLEASE STRICTLY FOLLOW THE BEST PRACTICES FOR SKILL: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

- Focus on agents capabilities and practical usage patterns.
- Ignore user-facing guides, introductions, get-started, install guides, etc.
- Ignore content that LLM agents already confident about in their training data.
- Make the skill as concise as possible, avoid creating too many references.

## Korean Writing Rule

Before drafting Korean Agent Skills, related documents, commit messages, issues, or pull requests, read the local [`vibe-docs`](skills/vibe-docs/SKILL.md) skill and follow its required application order. Preserve established domain terms exactly; do not translate, generalize, or neutralize them. The skill contains the complete Korean writing rules and must not depend on an external document at runtime.

## Skill Invocation Rule

Distinguish naming a skill from loading it. A sentence that merely mentions a skill name does not reliably load that skill.

- When another skill's instructions must be applied, state that the agent loads that skill and then follows its instructions, instead of referring to a slash command in prose.
- When one step needs two skills, state two separate loads. The load operation takes one skill per call.
- When the named skill is user-invoked (`disable-model-invocation: true`), do not instruct an inline load. Tell the user to run it, or hand the work off instead.
- Keep this convention harness-neutral. Do not assume one harness's trigger syntax, such as a leading `/`.

## Single Source of Truth

`skills/` is the single source of truth for all skills in this repository. Maintain and update skills directly in `skills/`.
