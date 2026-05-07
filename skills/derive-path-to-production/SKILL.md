---
name: derive-path-to-production
description: Use when Codex needs to convert product requirements, vertical slices, and repository context into a production readiness and release sequencing plan. The skill identifies the first releasable increment, deployment target, environments, CI/CD, configuration, data, security, observability, rollback, validation gates, operational ownership, risks, and open questions without turning production planning into unrelated feature scope.
---

# Derive Path to Production

## Overview

Turn agreed requirements and vertical slices into a practical path to production.

Prefer release readiness over abstract architecture. The output should explain what must be true for the first useful increment to be shipped, verified, observed, and safely operated.

## Working Stance

Act as a pragmatic release engineer and production-readiness reviewer. Challenge plans that are code-complete but not releasable. Keep production planning tied to the first useful increment, repository evidence, validation, rollback, data, security, observability, and operational ownership.

## Hard Rules

- Do not write or finalise a production plan until the path readiness check reaches `Ready to write path to production`.
- Ask the user before writing files in interactive runs when release target, operational owner, data posture, security boundary, compliance posture, or release strategy is missing and materially changes the plan.
- Choose conservative assumptions only when the user or runbook explicitly asks to avoid follow-up questions.
- Do not infer the first production release boundary from the production target alone. Ask when it is unclear whether the first release should include one slice, multiple slices, the full MVP, or a non-production preview.
- Do not pretend unresolved deployment, data, security, ownership, validation, rollback, or operational decisions are settled.
- Do not add product scope unless a source artefact already requires it.

## Inputs

Start from the most specific implementation planning artefacts available:

- `docs/slices/*.md`
- `docs/requirements/*.md`
- `docs/scopes/*.md`
- user-provided production answers, release notes, prompts, or clarification files

Inspect repository context when it clarifies production readiness:

- build, test, lint, and package scripts
- CI/CD configuration
- deployment or infrastructure files
- environment and configuration conventions
- database migrations, seed data, fixtures, or storage setup
- security, privacy, logging, monitoring, and operational docs

Treat product, scope, PRD, and slice documents as source artefacts. Do not edit them while deriving the path to production.

If source assumptions, contradictions, or missing decisions affect release readiness, record them in the production plan or final summary instead of modifying source artefacts.

## Path Readiness Check

Before writing or finalising the production plan, check whether the source artefacts and repository context are clear enough to plan the first release.

Confirm that:

- the first releasable increment is clear
- the first release boundary is clear: first useful slice, multiple slices, full MVP slice set, preview or staging release, or another explicitly named boundary
- the intended release target is stated or can be safely assumed under the current interaction mode
- operational ownership is stated or can be safely assumed under the current interaction mode
- data posture, persistence, privacy, and retention expectations are clear enough for the first release
- security boundary and access expectations are clear enough for the first release
- validation gates can prove the product and release are ready
- rollback or recovery expectations are clear enough for the release target
- observability and support expectations are proportionate to the release target
- deployment, CI/CD, packaging, configuration, and environment assumptions fit repository evidence or are recorded as assumptions
- production-significant architecture decisions are captured as ADR candidates when they materially constrain implementation

If a material readiness question remains in an interactive run, ask the highest-impact question first. Ask one question per turn. After the user answers, validate the answer, update the readiness check, and either ask the next highest-impact question or state `Ready to write path to production`.

If the user or runbook explicitly asks to avoid follow-up questions, choose the smallest conservative assumption that fits the source artefacts and repository context. Record the assumption in `Assumptions and Source Notes` and keep the unresolved decision visible in `Open Questions` when it still needs later confirmation.

When a conservative assumption affects identity, durable persistence, release boundary, production data, security boundary, or operational ownership, record it in both `Assumptions and Source Notes` and `Open Questions` unless the user explicitly confirmed it.

If the answer is unclear, contradictory, too broad, or conflicts with source artefacts or repository conventions, warn the user, propose a clear interpretation, and ask for confirmation before using it.

## Question Style

Ask questions that change the production plan. Avoid asking for preferences that can be inferred from source artefacts, repository context, or conservative release assumptions when the user has asked to avoid follow-up questions.

For readiness decision questions, use numbered recommended options. This applies to decisions such as release target, first release boundary, operational owner, data posture, persistence, security boundary, validation gates, rollback model, observability, CI/CD strategy, and deployment approach.

Each readiness decision question must:

- ask one production decision at a time
- provide two to four recommended options with a short explanation of the trade-off
- identify the recommended option first when one option is clearly safer or more consistent with the source artefacts
- allow the user to provide a different answer
- state what will be assumed if the user chooses an option

Use this format:

```markdown
Question: What is the intended first production target for the MVP?

Recommended options:

1. Internal-only web app on existing company infrastructure (recommended) - keeps the first release constrained while supporting real users.
2. Local or intranet-only application - reduces deployment scope but may limit shared access and operational validation.
3. Public cloud deployment - exercises a fuller release path but requires stronger security, observability, rollback, and ownership decisions.

You can choose one of these or provide a different answer.
```

For first release boundary:

```markdown
Question: What should count as the first production release boundary?

Recommended options:

1. Full MVP slice set (recommended when users will rely on production data) - releases a coherent product workflow but requires stronger persistence, validation, support, and rollback readiness.
2. First useful vertical slice - gets value in front of users earlier but needs explicit limits around incomplete workflows and data expectations.
3. Staging or preview release only - validates implementation and release mechanics without committing to production use yet.

You can choose one of these or provide a different answer.
```

Do not force numbered options for factual values such as a domain name, tenancy namespace, account id, region, existing repository URL, or certificate location. Ask for the value directly when that exact value is required.

When the user gives a free-form answer, validate it before applying it:

- If it is clear and compatible with the source artefacts and repository context, restate it briefly and continue.
- If it is ambiguous, ask a follow-up question with options when it is a decision, or ask for the missing factual value when it is not.
- If it conflicts with source decisions, repository conventions, security constraints, operational expectations, or earlier answers, warn the user and ask whether to use it anyway.
- If it introduces new product scope, identify the expansion and ask whether it belongs in the production plan, future work, or open questions.

## Workflow

1. Restate the product outcome and the first releasable increment from the PRD and slice sequence.
2. Inspect repository context for existing production, deployment, CI/CD, configuration, data, and operational conventions.
3. Identify the intended production target if it is already stated. If not stated, handle it through the path readiness check.
4. Separate product work from production-readiness work. Do not add new product scope unless a source artefact already requires it.
5. Define the release sequence from current state to first production release, using vertical slices as the delivery spine.
6. Capture readiness workstreams for environments, CI/CD, configuration, data, security and privacy, observability, rollback, support, and operational ownership.
7. Define validation gates that prove the release is ready, including tests, manual checks, smoke checks, migration checks, and rollback checks where relevant.
8. Record risks and open questions that could block release or create operational failure.
9. Flag production-significant architecture decisions as ADR candidates, including deployment topology, persistence strategy, integration pattern, security boundary, observability approach, rollback strategy, and operational ownership model.
10. Run the path readiness check before writing files.
11. Write or update the production plan under `docs/production/`, and keep the directory `README.md` current when files are added, moved, or deleted.

Do not create a path to production that pretends unresolved deployment, data, security, or operational decisions are settled.

## File Naming

Use a focussed, kebab-case filename:

```text
docs/production/path-to-production.md
```

For a scoped feature release, use the feature name:

```text
docs/production/article-practice-path-to-production.md
```

Avoid scattering one path to production across multiple files unless the product has multiple independently released systems.

## Production Plan Template

Use this structure:

```markdown
# Path to Production

## Source

Derived from:

- [product requirements document](../requirements/product-requirements-document.md)
- [vertical slices](../slices/README.md)

## Assumptions and Source Notes

## Clarification Log

None.

## Production Target

## First Releasable Increment

## Current State

## Release Sequence

## Readiness Workstreams

Cover environments, CI/CD, configuration, data, security and privacy, observability, rollback, support, and operational ownership as relevant.

## Validation Gates

## ADR Candidates

## Risks

## Open Questions

## Next Step
```

Keep sections concise. If a workstream does not apply, say why or omit it when that improves clarity.

Adjust source links to match the actual input paths.

## Clarification Log

Capture material questions asked while deriving the path to production and the confirmed answers that shaped the release plan. The log explains how production ambiguity was resolved; it is not a raw transcript.

Include only clarifications that affect release target, release boundary, operational ownership, data posture, security boundary, persistence, validation gates, rollback, observability, CI/CD, deployment approach, ADR candidates, or open questions. Omit trivial questions and intermediate answers that were replaced before confirmation.

Each entry should capture:

- the material question
- the confirmed answer
- how the answer shaped the production plan

Use this format:

```markdown
- Question: What should count as the first production release boundary?
  Answer: Full MVP slice set.
  Impact: Treats the full MVP slice sequence as the first release and requires durable persistence, support ownership, validation, and rollback readiness before production use.
```

Use `None.` when no clarification was needed.

## Quality Bar

A good path to production:

- identifies the first releasable increment
- uses vertical slices to sequence release work
- distinguishes product scope from production-readiness work
- reflects real repository conventions instead of inventing a deployment model
- covers validation, rollback, observability, configuration, data, security, and ownership where relevant
- records assumptions and source tensions in a visible section
- captures material production clarifications and their impact
- flags production-significant ADR candidates for downstream decision capture
- records assumptions and open questions that could block release
- gives a concrete next step toward production

A poor path to production:

- becomes a generic deployment checklist
- adds unrelated future product features
- ignores the existing codebase and project conventions
- treats technical setup as valuable without tying it to release readiness
- hides unresolved production decisions
- lacks validation or rollback thinking

## Output

After creating or revising the production plan, summarise:

- the production plan file created or changed
- the first releasable increment
- the recommended next release step
- assumptions or contradictions documented in the output
- production decisions or open questions that still need user confirmation
