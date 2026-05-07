---
name: derive-product-requirements-document
description: Use when Codex needs to convert an agreed product scope, MVP scope, or clarified feature scope into a Product Requirements Document before deriving vertical slices or implementation plans. The skill expands scope and lean-inception-style decisions into product-facing requirements, goals, non-goals, user journeys, acceptance criteria, success measures, constraints, and risks; runs a clarification loop for unresolved product decisions; and avoids writing a PRD that is not ready for slicing unless the user explicitly defers open questions.
---

# Derive Product Requirements Document

## Mission

Turn an agreed scope into a practical Product Requirements Document that is detailed enough to guide vertical slicing and implementation planning. A short user prompt should be enough: the skill owns the PRD clarification process and asks the necessary questions before finalising the PRD.

Prefer clarity over ceremony. The PRD should preserve product intent, carry forward lean-inception-style decisions, expose unresolved decisions, and avoid technical design unless a technical constraint changes product requirements.

## Hard Rules

- Do not finalise a PRD for vertical slicing until the clarification loop reaches `Ready to write PRD`.
- Do not leave material PRD questions open unless the user explicitly chooses to defer them.
- Treat existing `Open Questions` from the source scope, current PRD, or related artefacts as material blockers by default.
- Treat vague requirement placeholders as material blockers until they are made explicit or the user confirms the intended interpretation.
- Ask exactly one question at a time when the answer cannot be determined safely.
- Include recommended options for each question so the user can answer quickly or provide a different answer.
- Do not invent product decisions to keep the workflow moving.

## Inputs

Start from the most specific scope artefact available, usually one of:

- `docs/scopes/*.md`
- a clarified feature scope
- a user-provided scope document

Inspect the product description and related docs when they clarify intent, but do not expand the PRD beyond the agreed scope without calling it out.

Treat scope documents, product descriptions, prompts, issues, and related docs as inputs. Do not edit them while deriving the PRD.

If assumptions, contradictions, or source clarifications affect requirements, record them in the PRD's `Source Clarifications`, `Constraints`, `Risks`, or `Open Questions` section instead of modifying the input document.

## Clarification Loop

Before writing or finalising the PRD, build a material open-question list from the scope, product description, related docs, and local context. Include only questions that would change requirements, user journeys, acceptance criteria, success measures, constraints, risks, non-goals, domain language, architecture-significant constraints, or vertical slicing.

If any input artefact already has an `Open Questions` section, copy those questions into the material open-question list first. Do not remove, answer, or silently absorb existing open questions into requirements unless the answer is explicitly present in the source artefacts or the user confirms it.

Run a specificity check before declaring `Ready to write PRD`. Treat vague phrases as unresolved when they materially affect slicing or acceptance criteria, including:

- "minimum fields", "core metadata", "essential information", or "required details" without an explicit field list
- "simple", "basic", "lightweight", or "minimal" without a behavioural boundary
- "sort", "filter", "search", "highlight", "show clearly", or "make easy" without the required user-visible behaviour
- "activity", "history", "log", "audit trail", or "notes" without the required content
- "dashboard", "view", "detail", "summary", or "report" without the user-visible data needed for the first useful flow
- "reference", "attachment", "link", "file", "external resource", "related artefact", or "supporting material" without the required representation

If the source uses vague phrases but also provides enough explicit evidence to resolve them, record the resolution as source evidence in the clarification log. If the resolution depends on interpretation, ask the user to confirm it before treating the question as resolved.

When a requirement mentions a reference, attachment, link, note, file, external resource, or related artefact, define its representation. If the source does not say whether it is free text, a URL or path, an uploaded file, a selected existing record, or a managed object, ask the user before finalising the PRD.

If material open questions exist, ask the highest-impact question first using the question style below. Ask one question per turn. After the user answers, validate the answer, update the open-question list, and either ask the next highest-impact question or state `Ready to write PRD`.

If no material open questions remain, state `Ready to write PRD` and create or update the PRD.

Only defer an open question when the user explicitly chooses to defer it. Record deferred questions in `Open Questions` with the reason they were deferred and whether the PRD is still ready for vertical slicing.

If the answer is unclear, contradictory, too broad, or conflicts with repository conventions, warn the user, propose a clear interpretation, and ask for confirmation before using it.

When resolving an existing open question, record whether it was resolved by source evidence or by user confirmation. If the answer is only a reasonable inference, ask the user to confirm it before treating the question as resolved.

## Workflow

1. Restate the product outcome, first user, and the first useful flow from the scope.
2. Carry forward the scope's Out of Scope and Not List sections as PRD `Non-Goals`; distinguish deferred relevant work from ideas that are outside the product identity.
3. Translate trade-off decisions into constraints or decision notes that can guide later slicing.
4. Extract the first successful session and key failure paths from the first useful flow.
5. Convert requirements, the first successful session, and key failure paths into observable acceptance criteria.
6. Capture success measures that reflect user value, not vanity metrics.
7. Record constraints and risks, including assumptions raised during scoping.
8. Preserve domain-significant terms from the scope and check whether `docs/domain/ubiquitous-language.md` needs an update or an ambiguity note.
9. Preserve architecture-significant choices as constraints or explicit decision notes, and flag them as ADR candidates when they establish durable implementation, data, integration, deployment, or operational constraints.
10. Run the clarification loop before finalising the PRD.
11. Include a `Source` section that links to the scope document used as input.
12. Write or update the PRD as Markdown under `docs/requirements/`, and keep the directory `README.md` current when files are added, moved, or deleted.

## Question Style

Ask questions that change the PRD. Avoid asking for preferences that can be inferred from the scope, product description, repository, or chosen conservatively without changing product behaviour.

Each clarification question must:

- ask one decision at a time
- provide two to four recommended options with a short explanation of the trade-off
- identify the recommended option first when one option is clearly safer or more consistent with the source artefacts
- allow the user to provide a different answer
- state what will be assumed if the user chooses an option

Use this format:

```markdown
Question: What information is required to create the first useful record?

Recommended options:

1. Only the fields needed for the first useful flow (recommended) - keeps the MVP small and supports vertical slicing.
2. All fields mentioned in the source artefacts - captures more context but may expand the first version.
3. A required/optional field split - gives implementation more precision but requires more product decisions.

You can choose one of these or provide a different answer.
```

When the user gives a free-form answer, validate it before applying it:

- If it is clear and compatible with the scope, restate it briefly and continue.
- If it is ambiguous, ask a follow-up question with options.
- If it conflicts with source decisions, repository conventions, domain language, constraints, or earlier answers, warn the user and ask whether to use it anyway.
- If it introduces new scope, identify the expansion and ask whether it belongs in requirements, non-goals, or open questions.
- If it answers an existing open question, record that it was resolved by user confirmation.

If the user asks whether open questions remain, answer with the current open-question list and continue with the next highest-impact question. Do not merely say that open questions exist.

## Lean Inception Inputs

When the scope contains lean-inception-style outputs, map them into the PRD instead of creating separate ceremony sections:

- Vision, elevator pitch, or product intent -> `Summary`, `Problem`, and `Goals`.
- First user, persona, or beneficiary -> `Target User`.
- first useful flow -> `User Journeys`, including the first successful session and key failure paths, plus `Functional Requirements` and `Acceptance Criteria`.
- Out of Scope -> `Non-Goals`, labelled or grouped as deferred relevant work when useful.
- Not List -> `Non-Goals`, labelled or grouped as product-identity guardrails when useful.
- Trade-off sliders or decision priorities -> `Constraints` or explicit product decisions.
- Heaven/Hell, risks, or failure scenarios -> `Risks`, `Success Measures`, and relevant acceptance criteria.
- Open questions and ambiguous terms -> `Open Questions` and, when domain-significant, ubiquitous language updates.
- Architecture-significant decisions -> `Constraints` or explicit decision notes, plus ADR candidates for `$capture-architecture-decisions` when they materially constrain future implementation.

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

## Clarification Log

Capture material questions asked while deriving the PRD and the confirmed answers that shaped the requirements. The log explains how product ambiguity was resolved; it is not a raw transcript.

By default, keep the clarification log in the PRD after `Source Clarifications` and before `Summary`. Move it to a separate linked file only when the log is long, sensitive, audit-heavy, or would make the PRD hard to review.

Include only clarifications that affect requirements, acceptance criteria, success measures, constraints, risks, non-goals, domain language, architecture-significant constraints, or slicing direction. Omit trivial questions and intermediate answers that were replaced before confirmation.

Each entry should capture:

- the material question
- the confirmed answer
- how the answer was resolved: source evidence or user confirmation
- the impact on requirements, acceptance criteria, constraints, risks, or slicing

Use this format:

```markdown
- Question: What information is required to create the first useful record?
  Answer: Only the fields needed for the first useful flow.
  Resolved by: User confirmation.
  Impact: Keeps the first version small and gives vertical slicing a concrete data boundary.
```

## PRD Template

Use this structure:

```markdown
# Product Requirements Document

## Source

Derived from:

- [scope document](../scopes/mvp-scope.md)

## Source Clarifications

None.

## Clarification Log

None.

## Summary

## Target User

## Problem

## Goals

## Non-Goals

## User Journeys

Include the first successful session and the key failure paths the first useful flow must handle.

## Functional Requirements

## Acceptance Criteria

Cover both the first successful session and key failure paths with observable criteria.

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
- replaces vague placeholders with concrete product behaviour, field lists, UI expectations, or acceptance criteria
- keeps source documents immutable and records clarifications in the PRD
- separates goals from non-goals
- carries forward the scope's first useful flow, deferred Out of Scope items, product-identity Not List items, trade-offs, risks, and open questions
- describes the first successful session and key failure paths
- describes user-visible requirements rather than implementation tasks
- includes acceptance criteria that can be verified
- resolves material open questions before vertical slicing or records explicit deferrals with reasons

A poor PRD:

- restates the scope without adding decision clarity
- hides unresolved assumptions
- uses phrases like "core metadata", "minimum fields", or "basic controls" without defining them in domain terms
- leaves material slicing blockers open without user-confirmed deferral
- drops scope decisions that should constrain implementation
- turns into a technical architecture document
- includes future ideas as current requirements
- uses success metrics that do not reflect user value or operational value

## Output

After creating or revising the PRD, summarise:

- the PRD file created or changed
- the major product decisions captured
- the lean-inception-style inputs carried forward or intentionally omitted
- assumptions, contradictions, or source clarifications documented in the PRD
- the open questions that remain and whether they were explicitly deferred
- whether the PRD is ready for `derive-vertical-slices`
