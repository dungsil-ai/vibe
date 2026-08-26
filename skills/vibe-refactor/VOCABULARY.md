# Deep Module Vocabulary

Design **deep modules**: lots of behavior behind small interfaces, placed at clean boundaries, tested through those interfaces. The goal is one interface covering many callers, fixes that stay in one place, and easier tests.

In user-facing text (HTML reports, cards, questions, legends), use ordinary words. Do not stamp `seam`, `leverage`, `locality`, `depth`, or `golden` as labels. `module`, `interface`, `adapter`, and `boundary` are fine. Do not invent replacement jargon.

## Table of Contents

- Glossary — module, interface, implementation, depth, boundary, adapter
- Deep vs Shallow
- Principles
- Designing for Testability
- Relationships
- Rejected Phrasings

## Glossary

**Module** — Anything with an interface and an implementation. A function, class, package, or cross-layer slice. _Avoid_: unit, component, service.

**Interface** — Everything callers must know to use the module: not just types, but invariants, ordering, error modes, configuration, and performance. _Avoid_: API, signature (type surface only).

**Implementation** — The code inside the module. Distinct from **Adapter**: a small adapter can wrap a large implementation (Postgres repository), or a large adapter can wrap a small implementation (in-memory fake). Use "adapter" when talking about the boundary; otherwise "implementation".

**Depth** — How much behavior a caller can run per unit of interface learned. **Deep** when a lot sits behind a small interface. **Shallow** when the interface is as complex as the implementation. In user-facing text say "deep" / "shallow", not `depth`.

**Boundary** — A place you can change behavior without editing that place; where the module's interface sits. Where to put it is a separate decision from what sits behind it. In user-facing text say "boundary" or "where you test". Do not say `seam`. For a DDD bounded context, say "bounded context" so it does not mix with this boundary.

**Adapter** — The concrete thing that fills an interface at a boundary. Names the role, not what is inside.

Do not mint nouns for what callers gain or what maintainers gain. Write "one interface covers many callers" and "fixes stay in one place".

## Deep vs Shallow

**Deep module** = small interface + deep implementation:

```
┌─────────────────────┐
│   Small Interface   │  ← Few methods, simple parameters
├─────────────────────┤
│                     │
│  Deep Implementation│  ← Hides complex logic
│                     │
└─────────────────────┘
```

**Shallow module** = large interface + thin implementation (avoid):

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Many methods, complex parameters
├─────────────────────────────────┤
│  Thin Implementation            │  ← Merely passes through
└─────────────────────────────────┘
```

When designing interfaces, ask:

- Can we reduce method counts?
- Can we simplify parameters?
- Can more complexity be hidden inside?

## Principles

- **Depth is a property of the interface, not the implementation.** Internals may be small and swappable — they just are not public. A module may have an **outer boundary** plus **inner boundaries** used only by its own tests.
- **The Deletion Test.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is where you test.** Callers and tests pass through the same boundary. If you want to test *past* the interface, the module is probably misshapen.
- **Do not add a boundary for one adapter.** Add one only when there are two (usually production and test).

## Designing for Testability

1. **Accept dependencies rather than creating them.**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Return results rather than causing side effects.**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Keep the surface small.** Fewer methods = fewer tests. Simpler parameters = simpler setup.

## Relationships

- A **Module** has one **Interface**.
- **Depth** is measured against that interface.
- A **Boundary** is where that interface sits.
- An **Adapter** fills the interface at the boundary.
- Depth lets callers do more with one interface, and keeps fixes in one place.

## Rejected Phrasings

- **Depth as implementation lines over interface lines** (Ousterhout): rewards bloated implementations. Measure by what callers gain.
- **"Interface" as the TypeScript keyword or public methods only**: too narrow.
- **Stamping jargon as labels** (`seam`, `leverage`, `locality`, `depth`, `golden`).
- **Inventing replacement jargon** (join, caller gain, one-place change). Use ordinary words and sentences.
