---
name: derive-product-requirements-document
description: Use when Codex needs to convert an agreed product scope, MVP scope, or clarified feature scope into a Product Requirements Document before deriving vertical slices or implementation plans. The skill expands scope and lean-inception-style decisions into product-facing requirements, goals, non-goals, user journeys, acceptance criteria, success measures, constraints, risks, and open questions without inventing unresolved product decisions.
---

# Derive Product Requirements Document

## Overview

Turn an agreed scope into a practical Product Requirements Document that is detailed enough to guide slicing and implementation.

Prefer clarity over ceremony. The PRD should preserve product intent, carry forward lean-inception-style decisions, expose unresolved decisions, and avoid technical design unless a technical constraint changes product requirements.

## Inputs

Start from the most specific scope artefact available, usually one of:

- `docs/scopes/*.md`
- a clarified feature scope
- a user-provided scope document

Inspect the product description and related docs when they clarify intent, but do not expand the PRD beyond the agreed scope without calling it out.

## Workflow

1. Restate the product outcome, first user, and the first useful flow from the scope.
2. Carry forward the scope's Out of Scope and Not List sections as PRD `Non-Goals`; distinguish deferred relevant work from ideas that are outside the product identity.
3. Translate trade-off decisions into constraints or decision notes that can guide later slicing.
4. Extract the core user journey and required user-visible behaviours.
5. Convert requirements into observable acceptance criteria.
6. Capture success measures that reflect user value, not vanity metrics.
7. Record constraints, risks, and open questions, including assumptions raised during scoping.
8. Preserve domain-significant terms from the scope and check whether `docs/domain/ubiquitous-language.md` needs an update or an ambiguity note.
9. Ask the user when the PRD would otherwise require inventing a product decision.
10. Include a `Source` section that links to the scope document used as input.
11. Write or update the PRD as Markdown under `docs/requirements/`, and keep the directory `README.md` current when files are added, moved, or deleted.

## Lean Inception Inputs

When the scope contains lean-inception-style outputs, map them into the PRD instead of creating separate ceremony sections:

- Vision, elevator pitch, or product intent -> `Summary`, `Problem`, and `Goals`.
- First user, persona, or beneficiary -> `Target User`.
- first useful flow -> `User Journeys`, `Functional Requirements`, and `Acceptance Criteria`.
- Out of Scope -> `Non-Goals`, labelled or grouped as deferred relevant work when useful.
- Not List -> `Non-Goals`, labelled or grouped as product-identity guardrails when useful.
- Trade-off sliders or decision priorities -> `Constraints` or explicit product decisions.
- Heaven/Hell, risks, or failure scenarios -> `Risks`, `Success Measures`, and relevant acceptance criteria.
- Open questions and ambiguous terms -> `Open Questions` and, when domain-significant, ubiquitous language updates.

## File Naming

Use a focussed, kebab-case filename:

```text
docs/requirements/product-requirements-document.md
```

For a scoped feature PRD, use the feature name:

```text
docs/requirements/article-practice-prd.md
```

Avoid scattering one PRD across multiple files unless the product is large enough to justify it.

## PRD Template

Use this structure:

```markdown
# Product Requirements Document

## Source

Derived from:

- [scope document](../scopes/mvp-scope.md)

## Summary

## Target User

## Problem

## Goals

## Non-Goals

## User Journeys

## Functional Requirements

## Acceptance Criteria

## Success Measures

## Constraints

## Risks

## Open Questions
```

Keep sections concise. If a section does not apply, say why or omit it when that improves clarity.

Adjust the source link to match the actual input path. For example, if the PRD is created at `docs/requirements/product-requirements-document.md` from `docs/scopes/mvp-scope.md`, link to `../scopes/mvp-scope.md`.

## Quality Bar

A good PRD:

- makes product behaviour explicit enough to derive vertical slices
- separates goals from non-goals
- carries forward the scope's first useful flow, deferred Out of Scope items, product-identity Not List items, trade-offs, risks, and open questions
- describes user-visible requirements rather than implementation tasks
- includes acceptance criteria that can be verified
- preserves open questions instead of pretending they are answered

A poor PRD:

- restates the scope without adding decision clarity
- hides unresolved assumptions
- drops scope decisions that should constrain implementation
- turns into a technical architecture document
- includes future ideas as current requirements
- uses success metrics that do not reflect user value or operational value

## Output

After creating or revising the PRD, summarise:

- the PRD file created or changed
- the major product decisions captured
- the lean-inception-style inputs carried forward or intentionally omitted
- the open questions that remain
- whether the PRD is ready for `derive-vertical-slices`
