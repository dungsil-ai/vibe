---
name: vibe-modeling
description: Defines domain terms and records significant architectural decisions for the project. Use when defining domain vocabulary, recording architectural decisions, or when other skills need to update the domain model.
---

# Vibe Modeling

**Korean repository text:** When this skill writes or revises Korean documents, commit messages, issues, pull requests, reviews, or comments, apply `/vibe-docs` before saving or sending them. `/vibe-docs` controls wording only and does not expand this skill's authority or external side effects.

Use this skill when the domain model changes. Read the glossary before altering terms. Use concrete examples for non-obvious relationships. Record agreed terms immediately. Propose ADRs only for decisions meeting ADR criteria. Do not use this skill merely to read `CONTEXT.md`.

## File Structure

Most repositories maintain a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If `CONTEXT-MAP.md` exists at root, the repository contains multiple contexts. The map lists each context and its location:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← System-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← Context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files only when there is content. If `CONTEXT.md` is missing, create it after agreeing on the first term. If `docs/adr/` is missing, create it only when the first ADR is needed.

## During a Session

### Use Direct Language

- Use short, literal sentences for all questions, explanations, and records. Avoid idioms, metaphors, or culturally dependent expressions.
- In `CONTEXT.md`, write canonical terms in `Korean (English)` if in a bilingual context, or plain English.
- Use clear everyday terms (CEFR A1–A2) for general English names.
- Specialized English technical terms are used only when clearly standard for that domain.

### Compare Against Glossary

If the user uses a term or meaning conflicting with `CONTEXT.md`, surface the conflict immediately. Ask: "`CONTEXT.md` defines `Cancel` as X. Do you mean X or Y?"

### Clarify Ambiguous Language

If the user uses a term with multiple meanings, propose a single precise canonical term. Ask: "Do you mean `Customer` or `User`? They are distinct concepts."

### Use Concrete Examples

Use concrete examples when discussing domain relationships. Check edge cases around conceptual boundaries. Ask the user which concept each case falls under.

### Compare with Code

When the user describes how something works, compare their description with the code. Highlight differences: "Code cancels the entire `Order`. You mentioned cancelling part of an order. Which behavior is correct?"

### Update CONTEXT.md Immediately

Update `CONTEXT.md` immediately once a term is agreed upon. Do not defer recording. Use the format in [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md).

Keep only glossary terms in `CONTEXT.md`. Exclude implementation details, specs, working notes, and design decisions.

### Propose ADRs Only When Warranted

Do not create ADRs automatically. Propose an ADR only when all three conditions are true:

1. **Hard to change** — Significant cost to reverse the decision later.
2. **Non-obvious from code alone** — Future readers cannot deduce the reasoning from code alone.
3. **Evaluated real alternatives** — Real alternatives were evaluated and one was chosen for specific reasons.

If any condition is missing, do not propose an ADR. Use the format in [ADR-FORMAT.md](ADR-FORMAT.md).
