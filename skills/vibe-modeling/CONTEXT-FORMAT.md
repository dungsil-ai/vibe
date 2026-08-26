# CONTEXT.md Format

## Structure

```md
# {Context Name}

{One or two sentences describing what this context covers and why it exists.}

## Terms

**Order**:
A customer request specifying items and quantities to purchase.
_Avoid_: Purchase, Transaction

**Bill**:
A payment request sent to the customer after dispatching goods.
_Avoid_: Statement, Invoice

**Customer**:
An individual or organization placing orders.
_Avoid_: Guest, Buyer, Account
```

## Rules

- In bilingual settings, write canonical terms in `Korean (English)` order. In English-only settings, write in plain English.
- Use clear everyday vocabulary for general English names. Technical English terms are used only when standard in the domain.
- Write short, literal sentences in questions, explanations, and records. Avoid idioms, metaphors, or culturally dependent expressions.
- If multiple names exist for one concept, choose one canonical term and list alternatives under `_Avoid_`.
- Write definitions in 1–2 sentences. State what the term is, not what it does.
- Place only terms and definitions in `CONTEXT.md`. Do not include implementation details, specs, working notes, or design decisions.
- Include only terms unique to this context. Omit general programming concepts like timeouts, error types, or utility patterns.
- Group related terms under subheadings if numerous. Use a flat list for a single focused area.

## Single or Multiple Contexts

**Single Context:** Most repositories maintain a single `CONTEXT.md` at repository root.

**Multiple Contexts:** `CONTEXT-MAP.md` at repository root describes each context, its location, and relationships:

```md
# Context Map

## Contexts

- [Order](./src/ordering/CONTEXT.md) — Receives customer orders and manages status.
- [Bill](./src/billing/CONTEXT.md) — Generates bills and processes payments.
- [Delivery](./src/fulfillment/CONTEXT.md) — Picks and dispatches goods.

## Relationships

- **Order → Delivery**: Order sends new order details to Delivery. Delivery picks items and initiates dispatch.
- **Delivery → Bill**: Delivery sends dispatch information to Bill. Bill creates bills.
- **Order ↔ Bill**: Share Customer ID and Money amounts.
```

Selection criteria:

- Read `CONTEXT-MAP.md` if present to find contexts.
- Use single context if only root `CONTEXT.md` exists.
- If neither exists, create root `CONTEXT.md` upon agreeing on the first term.

If multiple contexts exist, determine which context the current topic belongs to. Ask the user if unclear.
