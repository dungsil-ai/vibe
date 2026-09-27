# Category Investigation Criteria

Read only the selected technical categories and `Finding format`. Require an actual contract violation or concrete cost, not merely the presence of a pattern.

## correctness

Inspect swallowed errors, boundaries/empty inputs, state transitions, cancellation/resource cleanup, async races, multi-write transactions, and retry idempotency. For type escapes, trace feasible inputs and calling paths.

## security

Trace trust boundaries from input to privileged APIs, SQL, shells, HTML, and filesystem paths; check server-side identity, ownership, and tenant validation. Judge uploads, mass assignment, sensitive logs, production configuration, and dependency risk by reachable paths. Never read and output secret values: report locations/types only and recommend rotation. Do not classify standard proxy or local development-tool behavior as vulnerabilities without evidence of added risk. Prioritize high-severity dependency advisories affecting runtime or build/distribution paths and state the current advisory source and lookup time. Do not generate attack reproductions or misuse procedures.

## performance

Inspect N+1, repeated-scan complexity, duplicate computation/requests, unbounded queries/payloads, rendering/network waterfalls, connection/queue use, and redundant CI work. Without frequency, scale, schema, or measurements, propose verification rather than claiming a proven bottleneck.

## tests

Check meaningful verification of critical payment/auth/data-mutation paths and unit/integration/E2E boundaries. Find tests that mirror implementation or only test mocks, and real-clock/network/order dependencies. Precede refactoring of high-churn untested areas with characterization tests. Missing or failing verification commands make a verification baseline a prerequisite.

## tech-debt

Inspect duplication requiring repeated edits, layering violations/cycles, concentrated responsibilities, actually unused code, inconsistent error/state handling, and excessive or missing abstractions. Do not recommend redesign based solely on file size or taste. Check representative conventions and the scope of ADR decisions together.

## dependencies

Inspect runtime/framework end-of-support, deprecated APIs actually used, abandoned critical-path dependencies, duplicate capabilities, and manifest/lockfile drift. Verify support/removal dates against official sources; flag uncertainty when unverified. Estimate affected files and compatibility cost without installing or upgrading.

## dx

Inspect actual failures or slow feedback in verification commands, CI, and development tooling, and hard-to-diagnose errors/logs. Report concrete reproduction/verification costs rather than missing configuration or agent instructions alone. Do not automatically create configuration or change user environments.

## docs

Inspect costs caused by public API contracts or operational/development procedures disagreeing with code, and recurring decision confusion from missing rationale. Do not elevate priority or request generic introductory guides merely because documentation is absent. Cite disagreements with relevant code, commands, or settled decisions.

## direction

Route to `vibe-next-plan` rather than duplicating investigation. Request repo-grounded investigation of unfinished intent, undelivered product goals, public capability asymmetries, and extensions supported by existing architecture. Target a separate two to four suggestions for full audits and four to six for direction alone, without padding. Prioritize settled product goals/ADRs and hand selected proposals off as `Kind: design-spike`.

## Finding format

Return the following for each candidate. State unknowns and how to verify them rather than inventing facts.

- Item ID, canonical category, and short title.
- Evidence: personally verified `file:line`, code/contract and calling-path explanation. Prefer the strongest two to five locations without inventing missing evidence. Include comparison SHAs and the evidence version in branch mode.
- Impact: actual incorrect behavior or cost. Direction describes user/product value.
- Effort: S (hours) / M (roughly a day) / L (multiple days), including tests, with assumptions.
- Risk: LOW / MED / HIGH and the contracts a fix could break.
- Confidence: HIGH (directly verified), MED (strong signal, verification needed), LOW (investigation needed). Distinguish confidence from whether verification commands ran.
- Improvement sketch and trade-offs: alternative benefits, costs, and maintenance burden. Do not write an implementation plan.
- Dependencies, unresolved questions, prerequisite verification/conventions/ADRs, and proposed plan kind.
- Branch provenance: `introduced` / `pre-existing` with comparison evidence. Separate unverifiable origins as investigation needed.
- Audited/excluded scope, commands actually run with results, and reasons for skipped checks.

Reject low-value or intentional behavior with reasons. Follow the user's and repository's output-language instructions for reports; omit secret values and unnecessary raw dumps.
