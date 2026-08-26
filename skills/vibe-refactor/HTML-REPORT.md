# HTML Report Format

Architecture reviews render as a single self-contained HTML file in the OS temporary directory. Tailwind and Mermaid load via CDN. Mermaid handles graph-shaped diagrams reliably, while bespoke divs and inline SVGs handle editorial visualizations (mass diagrams, cross-sections). Mix both — do not rely solely on Mermaid to avoid uniformity.

Write the report in plain English. Titles, legends, cards, outcomes, and diagram labels must not stamp `seam`, `leverage`, `locality`, `depth`, or `golden` as labels. CSS class names may stay in English.

## Table of Contents

- Scaffolding — Self-contained HTML skeleton
- Header — Report title block
- Candidate Cards — Markup per candidate
- Diagram Patterns — Mermaid graphs, bespoke boxes, cross-sections, mass diagrams, folding call graphs
- Style Guide — Tailwind conventions
- Top Recommendation Section
- Tone

## Scaffolding

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* Small custom layer for items Tailwind cannot handle cleanly:
         dashed boundaries, sketch-like arrowheads */
      .join { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

Repository name, date, concise legend: solid box = module, dashed line = boundary, red arrow = leak, bold dark box = deep module. No introductory paragraphs — straight to candidates.

## Candidate Cards

Diagrams carry the weight. Prose is sparse and plain. Use the concepts from [VOCABULARY.md](VOCABULARY.md), unpacked in ordinary words — do not paste jargon as labels.

Each candidate is an `<article>`:

- **Title** — Short, names the deepening (e.g. "Fold order intake pipeline").
- **Badge Row** — Recommendation strength (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), plus dependency classification tags (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Files** — Monospace list, `font-mono text-sm`.
- **Before/After Diagrams** — The core. Two columns, side by side. See patterns below.
- **Problem** — One sentence. What hurts.
- **Solution** — One sentence. What changes.
- **Outcomes** — Bullets, each ≤8 words. E.g. "Tests hit one interface", "Stops pricing logic leak", "Deletes 4 shallow wrappers".
- **ADR Callout** (where applicable) — One line in an amber box.

No explanatory paragraphs. If a diagram requires a paragraph to be understood, redraw the diagram.

## Diagram Patterns

Choose patterns fitting each candidate. Mix them. Do not make every diagram look the same — diversity is the point.

Keep code identifiers (type and file names) as-is. Use plain words for concept labels (deep module, boundary, implementation).

### Mermaid Graphs (Workhorse for dependencies / call flows)

Use Mermaid `flowchart` or `graph` when the point is "X calls Y, Y calls Z, observe the tangle". Wrap in Tailwind-styled cards so they don't look jarring. Use classDefs to color leaking edges red and deep modules dark. Sequence diagrams fit "Before: 6 round trips; After: 1".

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Bespoke Boxes and Arrows (When Mermaid layouts fight you)

Modules as `<div>`s with borders and labels. Arrows as inline SVG `<line>` or `<path>` positioned absolutely over relative containers. Use when the "After" diagram needs a single thick-bordered deep module with grayed-out internals — Mermaid struggles to render that weight cleanly.

### Cross-Sections (Great for layered shallowness)

Stack of horizontal bands (`h-12 border-l-4`) showing layers calls pass through. Before: 6 thin layers doing nothing. After: 1 thick band labeled with consolidated responsibilities.

### Mass Diagrams (When interface is as broad as implementation)

Two rectangles per module — one for interface surface area, one for implementation. Before: interface rectangle almost as tall as implementation rectangle (shallow). After: short interface rectangle, tall implementation rectangle (deep).

### Folding Call Graphs

Before: function call tree rendered as nested boxes. After: same tree folded into a single box, with calls now internal and faded inside.

## Style Guide

- Editorial feel rather than corporate dashboard. Generous whitespace. Optional serif headers (`font-serif` pairs well with stone/slate).
- Restrained color palette: one accent color (emerald or indigo), red for leaks, amber for warnings.
- Maintain diagram heights at ~320px so before/after sit comfortably side by side without scrolling.
- Use `text-xs tracking-wide` for module labels in diagrams. Do not render English jargon in all caps (`SEAM`, `LEVERAGE`).
- Scripts restricted to Tailwind CDN and Mermaid ESM import. The report is otherwise static — no app code, no interactivity beyond Mermaid's own rendering.

## Top Recommendation Section

One larger card. Candidate name, one-sentence rationale, anchor link to card. Nothing more.

## Tone

Plain and concise. Use the concepts in [VOCABULARY.md](VOCABULARY.md), but unpack them in ordinary sentences.

**Do not write in user-facing text:** `seam`, `leverage`, `locality`, `depth`, `golden`.

**Fine to use:** module, interface, implementation, adapter.

**Idiomatic phrasing:**

- "Order intake module is shallow — interface is almost identical to implementation."
- "Pricing leaks across the boundary."
- "Deepen: one interface, one place to test."
- "Two adapters justify a boundary: HTTP for production, in-memory for testing."

**Outcome bullets** name the gain in plain words: *"bugs gather in one module"*, *"one interface, many callers"*, *"interface shrinks; implementation absorbs wrappers"*. "Easier to maintain" is fine. Do not prefix bullets with `locality:` or `leverage:`.

No hedging, no preambles, no "it is worth noting that...". If a sentence can be a bullet, make it a bullet. If a bullet can be trimmed, trim it.
