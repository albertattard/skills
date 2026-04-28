---
name: derive-path-to-production
description: Use when Codex needs to convert product requirements, vertical slices, and repository context into a production readiness and release sequencing plan. The skill identifies the first releasable increment, deployment target, environments, CI/CD, configuration, data, security, observability, rollback, validation gates, operational ownership, risks, and open questions without turning production planning into unrelated feature scope.
---

# Derive Path to Production

## Overview

Turn agreed requirements and vertical slices into a practical path to production.

Prefer release readiness over abstract architecture. The output should explain what must be true for the first useful increment to be shipped, verified, observed, and safely operated.

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

## Workflow

1. Restate the product outcome and the first releasable increment from the PRD and slice sequence.
2. Inspect repository context for existing production, deployment, CI/CD, configuration, data, and operational conventions.
3. Identify the intended production target if it is already stated. If not stated, choose the smallest conservative target that fits the product and record it as an assumption.
4. Separate product work from production-readiness work. Do not add new product scope unless a source artefact already requires it.
5. Define the release sequence from current state to first production release, using vertical slices as the delivery spine.
6. Capture readiness workstreams for environments, CI/CD, configuration, data, security and privacy, observability, rollback, support, and operational ownership.
7. Define validation gates that prove the release is ready, including tests, manual checks, smoke checks, migration checks, and rollback checks where relevant.
8. Record risks and open questions that could block release or create operational failure.
9. Ask the user before writing files when the production target, operational owner, compliance posture, data handling, or release strategy materially changes the plan and the user has not asked to proceed with assumptions.
10. When running non-interactively or when the user asks to avoid follow-up questions, choose the smallest conservative assumptions that fit the source artefacts and repository context, then record those assumptions and unresolved decisions in the production plan.
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

## Production Target

## First Releasable Increment

## Current State

## Release Sequence

## Readiness Workstreams

Cover environments, CI/CD, configuration, data, security and privacy, observability, rollback, support, and operational ownership as relevant.

## Validation Gates

## Risks

## Open Questions

## Next Step
```

Keep sections concise. If a workstream does not apply, say why or omit it when that improves clarity.

Adjust source links to match the actual input paths.

## Quality Bar

A good path to production:

- identifies the first releasable increment
- uses vertical slices to sequence release work
- distinguishes product scope from production-readiness work
- reflects real repository conventions instead of inventing a deployment model
- covers validation, rollback, observability, configuration, data, security, and ownership where relevant
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
