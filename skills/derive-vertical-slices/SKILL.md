---
name: derive-vertical-slices
description: Use when Codex needs to convert a clarified Product Requirements Document into ordered vertical slice Markdown files. Prefer PRDs under docs/requirements/ as input; use scope documents only when the PRD step is intentionally skipped. The skill runs a slice readiness check, asks for clarification when slice boundaries or ordering are ambiguous, derives user-visible end-to-end slices, avoids horizontal technical task breakdowns, and writes slice documents under docs/slices/.
---

# Derive Vertical Slices

## Overview

Turn a Product Requirements Document into small, ordered vertical slices that can be implemented and reviewed one at a time.

Prefer user-visible outcomes over technical layers. A slice should be demoable or verifiable independently, even when it is intentionally thin.

## Hard Rules

- Do not write slice files until the slice readiness check reaches `Ready to write slices`.
- Treat unresolved PRD questions as blockers when they affect slice boundaries, ordering, acceptance criteria, dependencies, or the first useful implementation path.
- Ask exactly one question at a time when a slicing decision cannot be determined safely.
- Include recommended options for each question so the user can answer quickly or provide a different answer.
- Do not hide product ambiguity inside `Assumptions and Source Notes` when it changes what should be sliced.
- Do not silently record source tensions when they change implementation sequencing, prerequisites, fixtures, seed data, assets, persistence, or release readiness.
- Do not reopen broad product discovery unless the source artefacts are not ready for slicing.

## Inputs

Start from the most specific requirements artefact available:

- `docs/requirements/*.md`

Use a scope document only when the PRD step is intentionally skipped:

- `docs/scopes/*.md`
- a clarified feature description
- a user-provided scope document

Inspect nearby docs when they clarify intent, but do not expand scope beyond the selected source without calling it out.

Treat PRDs, scope documents, and other source artefacts as inputs. Do not edit them while deriving slices.

If assumptions, contradictions, or source clarifications affect slicing, record them in the generated slice files or final summary instead of modifying the input document.

## Slice Readiness Check

Before writing or revising slice files, check whether the source PRD is clear enough to derive ordered vertical slices.

Confirm that:

- the first useful user flow is clear
- the first slice can produce a user-visible outcome
- slice boundaries are end-to-end rather than technical layers
- ordering reflects user value, risk, and dependencies
- unresolved source questions do not change slice boundaries, ordering, or acceptance criteria
- each slice can have observable acceptance criteria
- architecture-significant decisions are already captured, deferred, or flagged as ADR candidates

Treat implementation-shaping ambiguity as a blocker. Ask before writing slices when the source includes:

- deferred content, seed data, fixtures, or assets that a slice needs to run
- vague persistence, reset, recovery, import, export, notification, or integration behaviour
- phrases such as "smallest coherent behaviour", "limited MVP persistence", "basic support", "simple setup", or "use fixture data" without a concrete boundary
- source tension between something required for a slice and something deferred from the MVP
- unclear ownership between product slice, technical prerequisite, content task, data task, or release task
- missing strategy for externally visible dependencies that affect whether the slice can be demonstrated

If any item is not clear enough, ask the highest-impact slicing question first using the question style below. Ask one question per turn. After the user answers, validate the answer, update the readiness check, and either ask the next highest-impact question or state `Ready to write slices`.

Only defer an open slicing question when the user explicitly chooses to defer it. Record deferred questions in `Assumptions and Source Notes` for the affected slice, or in the final summary if no slice should carry it.

If the answer is unclear, contradictory, too broad, or conflicts with source decisions, warn the user, propose a clear interpretation, and ask for confirmation before using it.

## First Slice Rule

The first slice should normally complete the smallest successful user journey from entry point to observable value.

Do not make the first slice only:

- render the first screen
- create a data model
- load fixture data
- show a form, prompt, list, or page without accepting the main user action
- prepare navigation, scaffolding, storage, or integration setup

The first slice should usually include:

- an entry point
- one valid user action
- the smallest useful system response
- observable confirmation, feedback, result, or state change
- enough data or fixture content to demonstrate the behaviour

Split the first successful journey only when it is too large or risky to implement safely in one change. If splitting is necessary, explain why and make the first slice still produce meaningful user-visible value.

## Workflow

1. Restate the core outcome from the PRD or selected source document.
2. Use the first useful flow as the starting point for the first implementation slice.
3. Use PRD risks, constraints, and open questions to shape slice boundaries.
4. Derive ordered slices where each slice adds one meaningful user-visible capability.
5. Push technical setup, scaffolding, data modelling, tests, and styling into slices only when needed to deliver that slice.
6. Challenge horizontal slices such as "build UI", "add data model", "wire storage", or "set up persistence"; rewrite them as end-to-end outcomes.
7. Carry architecture-significant constraints into `Assumptions and Source Notes`, and flag ADR candidates when slice boundaries depend on durable implementation, data, integration, or deployment choices.
8. Apply the first slice rule so the first slice proves the smallest successful user journey unless there is a documented reason to split it.
9. Run the slice readiness check before writing files.
10. Include a `Source` section in each slice file that links to the PRD or source document used as input.
11. Use `SLICE-NNNN` as the slice number, where `NNNN` is a zero-padded sequence number.
12. Use the full `SLICE-NNNN` identifier everywhere the slice is referenced: filename, title, source links, task source links, and final summaries.
13. Write one Markdown file per slice under `docs/slices/`.

Do not create a slice that depends on an unresolved product decision unless the slice records that dependency clearly.

## Question Style

Ask questions that change the slice plan. Avoid asking broad product discovery questions that should have been resolved during scope or PRD work unless the source artefacts are not ready for slicing.

Each clarification question must:

- ask one slicing decision at a time
- provide two to four recommended options with a short explanation of the trade-off
- identify the recommended option first when one option is clearly safer or more consistent with the source artefacts
- allow the user to provide a different answer
- state what will be assumed if the user chooses an option

Use this format:

```markdown
Question: Which capability should become the first vertical slice?

Recommended options:

1. The smallest end-to-end happy path (recommended) - proves the product flow quickly and keeps the first implementation slice thin.
2. The riskiest user-visible behaviour - reduces uncertainty earlier but may require more setup.
3. The core data lifecycle - gives later slices a stable foundation but may feel less immediately useful to a user.

You can choose one of these or provide a different answer.
```

For content or fixture ambiguity:

```markdown
Question: How should the content needed by the slice be handled?

Recommended options:

1. Use minimal fixture content for implementation slices and track production content separately (recommended) - keeps the slice demonstrable without silently expanding product scope.
2. Include production-ready content in the slice - makes the slice closer to release-ready but expands the work into content curation.
3. Treat content preparation as a prerequisite before this slice can be implemented - keeps the slice precise but may block implementation.

You can choose one of these or provide a different answer.
```

For persistence or reset ambiguity:

```markdown
Question: What persistence or reset behaviour should this slice assume?

Recommended options:

1. Session-local behaviour only (recommended) - keeps the first implementation small and avoids durable storage decisions.
2. Browser-local persistence - preserves progress across refreshes but introduces storage behaviour and reset rules.
3. Explicit reset or practice-again flow - supports repeated use after completion without broader account or sync requirements.

You can choose one of these or provide a different answer.
```

When the user gives a free-form answer, validate it before applying it:

- If it is clear and compatible with the PRD, restate it briefly and continue.
- If it is ambiguous, ask a follow-up question with options.
- If it conflicts with source decisions, repository conventions, domain language, constraints, or earlier answers, warn the user and ask whether to use it anyway.
- If it introduces new scope, identify the expansion and ask whether it belongs in a slice, outside the current slice set, or in an unresolved question.

## File Naming

Use the next available sequence number:

```text
docs/slices/SLICE-0001-submit-first-request.md
docs/slices/SLICE-0002-review-request-status.md
```

Do not renumber existing slices. When updating existing bare-numeric slice files, preserve their numeric sequence and rename only to add the `SLICE-` prefix when references can be updated. Do not use bare numeric identifiers such as `0001` for slices; use the full `SLICE-0001` form everywhere.

Keep each file focused on one slice.

## Slice Template

Use this structure for each slice:

```markdown
# SLICE-NNNN. Slice Title

## Source

Derived from:

- [product requirements document](../requirements/product-requirements-document.md)

## Outcome

Describe the user-visible result in one or two sentences.

## Includes

- List behaviour, content, UI, state, and verification needed for this slice.

## Excludes

- List tempting work that should remain out of this slice.

## Assumptions and Source Notes

- Capture assumptions, contradictions, source clarifications, unresolved decisions, risks, or open questions that affect this slice.

## Clarification Log

- Question: Capture only slicing questions that changed boundaries, ordering, dependencies, or acceptance criteria.
  Answer: Capture the confirmed answer.
  Impact: Explain how the answer shaped the slice plan.

## Acceptance Criteria

- Use observable criteria that can be manually verified or tested.

## Notes

- Capture dependencies, sequencing, or implementation notes that do not fit the sections above.
```

Omit `Notes` only when there is nothing useful to say.

Adjust the source link to match the actual input path. For example, if a slice is created at `docs/slices/SLICE-0001-submit-first-request.md` from `docs/requirements/product-requirements-document.md`, link to `../requirements/product-requirements-document.md`.

## Quality Bar

A good slice:

- cuts through the experience end to end
- can be demonstrated independently
- has a clear observable user outcome
- includes a valid user action and useful system response unless there is a documented reason to split them
- is small enough to implement without dragging in unrelated future scope
- respects known PRD risks, constraints, and open questions
- documents assumptions, contradictions, and unresolved decisions that affect the slice
- leaves the codebase in a coherent state

A poor slice:

- is only a technical layer
- cannot be observed by a user
- stops at showing a screen, page, form, list, or prompt without accepting the main user action
- exists mainly to prepare for imagined future work
- bundles several unrelated outcomes together
- hides a contradiction or unresolved product decision

## Clarification Log

Capture material questions asked while deriving vertical slices and the confirmed answers that shaped the slice plan. The log explains how slicing ambiguity was resolved; it is not a raw transcript.

By default, keep the clarification log in the affected slice document after `Assumptions and Source Notes` and before `Acceptance Criteria`. If a decision affects the whole slice set, include it in the first slice and reference the impact clearly. Move it to a separate linked file only when the log is long, sensitive, audit-heavy, or would make the slice documents hard to review.

Include only clarifications that affect slice boundaries, ordering, dependencies, acceptance criteria, architecture-significant constraints, or whether a slice is genuinely vertical. Omit trivial questions and intermediate answers that were replaced before confirmation.

Use `None.` when no clarification was needed for a slice.

## Output

After creating or revising slice files, summarise:

- slice files created or changed
- the recommended first implementation slice
- assumptions, contradictions, or material clarifications documented in the output
- any slicing decisions or open questions that still need user confirmation
