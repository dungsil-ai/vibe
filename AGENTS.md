# Skills Generate
Generate [Agent Skills](https://agentskills.io/home) from project documentation.

PLEASE STRICTLY FOLLOW THE BEST PRACTICES FOR SKILL: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

- Focus on agents capabilities and practical usage patterns.
- Ignore user-facing guides, introductions, get-started, install guides, etc.
- Ignore content that LLM agents already confident about in their training data.
- Make the skill as concise as possible, avoid creating too many references.

## Korean Writing Rule

Before drafting Korean Agent Skills, related documents, commit messages, issues, or pull requests, read the local [`vibe-docs`](skills-raw/vibe-docs/SKILL.md) skill and follow its required application order. Preserve established domain terms exactly; do not translate, generalize, or neutralize them. The skill contains the complete Korean writing rules and must not depend on an external document at runtime.

## Translation Meaning Preservation

When translating `skills-raw` into `skills`, translate the instruction text, not the behavior it requires.

- Preserve every output-language requirement exactly. A source rule that says to write in Korean must still require Korean in the translated skill; never replace it with English or remove it.
- Preserve literal language contracts and values, including `Korean (English)` order, Korean definitions and labels, Korean CEFR limits, and Korean field values consumed by other files.
- Translate examples or template text only when they are explanatory. Keep them in Korean when they are required output or demonstrate a Korean-only contract.
- Compare the completed translation with the source for semantic equivalence before saving. An output-language flip, weakened requirement, broadened exception, or translated literal value is a failed translation.
