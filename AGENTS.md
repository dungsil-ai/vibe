# Skills Generate
Generate [Agent Skills](https://agentskills.io/home) from project documentation.

PLEASE STRICTLY FOLLOW THE BEST PRACTICES FOR SKILL: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

- Focus on agents capabilities and practical usage patterns.
- Ignore user-facing guides, introductions, get-started, install guides, etc.
- Ignore content that LLM agents already confident about in their training data.
- Make the skill as concise as possible, avoid creating too many references.

## Korean Writing Rule

When a task creates or updates an Agent Skill, or writes related documents, commit messages, issues, or pull requests, use the local [`vibe-docs`](skills-raw/vibe-docs/SKILL.md) skill. It contains the complete Korean writing rules and must not depend on an external document at runtime.
