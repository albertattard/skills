---
name: capture-architecture-decisions
description: Use when Codex needs to identify, create, update, supersede, or review Architecture Decision Records (ADRs) for durable software architecture choices. This skill always writes concise Michael Nygard-style ADRs with Status, Context, Decision, and Consequences. Trigger this skill when work involves architecture decisions, technical trade-offs, platform choices, data ownership, integration patterns, security boundaries, deployment topology, persistence strategy, API contracts, cross-cutting constraints, or when existing planning artefacts mention ADR candidates or unresolved architecture decisions.
---

# Capture Architecture Decisions

## Overview

Capture durable architecture choices as concise Michael Nygard-style Architecture Decision Records. This skill is intentionally opinionated: every ADR uses the Nygard structure of `Status`, `Context`, `Decision`, and `Consequences` unless the repository already has an incompatible ADR convention.

Prefer decision clarity over ceremony: write ADRs only for choices that materially constrain future implementation, operation, integration, or evolution.

## ADR Criteria

Create or update an ADR when a decision:

- is hard or expensive to reverse
- affects multiple modules, teams, slices, services, integrations, environments, or releases
- establishes a persistent constraint, dependency, convention, or boundary
- resolves a meaningful trade-off among credible alternatives
- changes production, security, data, observability, deployment, or operational posture
- supersedes or contradicts a previous ADR

Do not create an ADR for routine implementation details, local refactors, naming choices, one-off task sequencing, or decisions already fully contained inside a task without wider architectural impact.

## Inputs

Inspect the most relevant local context before writing:

- existing ADRs under `docs/adrs/`
- scope, PRD, slice, production, and task artefacts under `docs/`
- source code, tests, configuration, deployment files, migrations, and package manifests
- user-provided architecture notes, prompts, issues, diagrams, or review comments

Treat source artefacts as inputs. Do not rewrite scope, PRD, slice, production, or task documents merely to make them match the ADR. If a source artefact is contradicted, record the contradiction in the ADR context and mention the follow-up in the final summary.

## Workflow

1. Identify the architecture decision being made or reviewed.
2. Check `docs/adrs/` for existing ADRs before creating a new one.
3. If an existing ADR is still valid, reference it instead of duplicating it.
4. If the decision changes a previous ADR, create a new ADR with status `Accepted` or `Proposed` and mark the old ADR as `Superseded`, including a `Superseded By` link to the new ADR.
5. Ask the user before writing when the decision, status, or selected option cannot be determined safely from context.
6. When running non-interactively or when the user asks to avoid follow-up questions, choose `Proposed` status for unresolved decisions and record the uncertainty in `Context` or `Consequences`.
7. Use the current date in `DD.MM.YYYY` format for `Created On` and `Updated On` unless the source artefact clearly provides the decision date. For a new ADR, set `Created On` and `Updated On` to the same date. When changing status later, preserve `Created On` and update `Updated On`.
8. Use `ADR-NNNN` as the decision number, where `NNNN` is a zero-padded sequence number.
9. Use the full `ADR-NNNN` identifier everywhere the decision is referenced: filename, title, status metadata, ADR index, supersession links, task source links, and final summaries.
10. Write ADRs under `docs/adrs/` using the decision number and kebab-case title.
11. Keep `docs/adrs/README.md` current when ADRs are added, renamed, or superseded.

## File Naming

Use the next available sequence number:

```text
docs/adrs/ADR-0001-use-postgresql-for-primary-storage.md
docs/adrs/ADR-0002-publish-events-through-outbox.md
```

Do not renumber existing ADRs. Do not use bare numeric identifiers such as `0001` for ADRs; use the full `ADR-0001` form everywhere.

## ADR Template

Use this Michael Nygard-style structure for every ADR:

```markdown
# ADR-NNNN. Decision Title

## Status

|                     |            |
| ------------------- | ---------- |
| **Status**          | Accepted   |
| **Created On**      | DD.MM.YYYY |
| **Updated On**      | DD.MM.YYYY |
| **Decision Number** | ADR-NNNN   |

## Context

Describe the forces at play, including constraints, trade-offs, source artefacts, and relevant alternatives. Make the decision understandable without requiring the reader to reconstruct the whole discussion.

## Decision

State the chosen architecture decision directly.

## Consequences

Describe the positive, negative, and neutral consequences. Include follow-up work, migration impact, operational impact, and risks when relevant.
```

For superseded ADRs, use this `Status` table shape:

```markdown
## Status

|                     |                                              |
| ------------------- | -------------------------------------------- |
| **Status**          | Superseded                                   |
| **Created On**      | DD.MM.YYYY                                   |
| **Updated On**      | DD.MM.YYYY                                   |
| **Superseded By**   | [ADR-NNNN](./ADR-NNNN-new-decision-title.md) |
| **Decision Number** | ADR-NNNN                                     |
```

Keep the core sections intact. Do not add custom sections unless the repository already has an ADR convention that requires them. The `Status` section must use the metadata table form. Valid status values are `Proposed`, `Accepted`, `Deprecated`, or `Superseded`.

## ADR Index

Use this structure for `docs/adrs/README.md`:

```markdown
# Architecture Decision Records

## Records

| ADR | Status | Decision |
| --- | --- | --- |
| [ADR-0001. Decision Title](ADR-0001-decision-title.md) | Accepted | One sentence summary. |
```

Use the status value from each ADR's metadata table in the index. Include superseded ADRs in the index so the decision history remains traceable.

## Quality Bar

A good ADR:

- records one decision, not a design document
- explains why the decision is needed now
- names the forces and trade-offs that make the decision non-trivial
- states the decision in one or two direct paragraphs
- makes consequences explicit, including downsides
- links to source artefacts or previous ADRs when useful
- preserves unresolved uncertainty as `Proposed` instead of pretending the decision is settled

A poor ADR:

- documents an obvious implementation detail
- hides alternatives or trade-offs
- reads like a task list or implementation plan
- mixes several independent decisions in one file
- rewrites history by editing an accepted ADR instead of superseding it

## Output

After creating or revising ADRs, summarise:

- ADR files created or changed
- status of each ADR
- previous ADRs referenced or superseded
- assumptions, contradictions, or unresolved decisions documented
- source artefacts that may need follow-up updates
