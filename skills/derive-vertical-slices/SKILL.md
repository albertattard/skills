---
name: derive-vertical-slices
description: Use when Codex needs to convert a Product Requirements Document into ordered vertical slice Markdown files. Prefer PRDs under docs/requirements/ as input; use scope documents only when the PRD step is intentionally skipped. The skill derives user-visible end-to-end slices, avoids horizontal technical task breakdowns, asks for clarification when slice boundaries are ambiguous, and writes slice documents under docs/slices/.
---

# Derive Vertical Slices

## Overview

Turn a Product Requirements Document into small, ordered vertical slices that can be implemented and reviewed one at a time.

Prefer user-visible outcomes over technical layers. A slice should be demoable or verifiable independently, even when it is intentionally thin.

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

## Workflow

1. Restate the core outcome from the PRD or selected source document.
2. Use the first useful flow as the starting point for the first implementation slice.
3. Use PRD risks, constraints, and open questions to shape slice boundaries.
4. Derive ordered slices where each slice adds one meaningful user-visible capability.
5. Push technical setup, scaffolding, data modelling, tests, and styling into slices only when needed to deliver that slice.
6. Challenge horizontal slices such as "build UI", "add data model", "wire storage", or "set up persistence"; rewrite them as end-to-end outcomes.
7. Carry architecture-significant constraints into `Assumptions and Source Notes`, and flag ADR candidates when slice boundaries depend on durable implementation, data, integration, or deployment choices.
8. Ask the user before writing files if slice boundaries, count, ordering, assumptions, or contradictions materially affect product direction.
9. Include a `Source` section in each slice file that links to the PRD or source document used as input.
10. Write one Markdown file per slice under `docs/slices/`.

Do not create a slice that depends on an unresolved product decision unless the slice records that dependency clearly.

## File Naming

Use zero-padded numeric prefixes and kebab-case titles:

```text
docs/slices/0001-submit-first-request.md
docs/slices/0002-review-request-status.md
```

Keep each file focused on one slice.

## Slice Template

Use this structure for each slice:

```markdown
# Slice Title

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

## Acceptance Criteria

- Use observable criteria that can be manually verified or tested.

## Notes

- Capture dependencies, sequencing, or implementation notes that do not fit the sections above.
```

Omit `Notes` only when there is nothing useful to say.

Adjust the source link to match the actual input path. For example, if a slice is created at `docs/slices/0001-submit-first-request.md` from `docs/requirements/product-requirements-document.md`, link to `../requirements/product-requirements-document.md`.

## Quality Bar

A good slice:

- cuts through the experience end to end
- can be demonstrated independently
- has a clear observable user outcome
- is small enough to implement without dragging in unrelated future scope
- respects known PRD risks, constraints, and open questions
- documents assumptions, contradictions, and unresolved decisions that affect the slice
- leaves the codebase in a coherent state

A poor slice:

- is only a technical layer
- cannot be observed by a user
- exists mainly to prepare for imagined future work
- bundles several unrelated outcomes together
- hides a contradiction or unresolved product decision

## Output

After creating or revising slice files, summarise:

- slice files created or changed
- the recommended first implementation slice
- assumptions or contradictions documented in the output
- any scope decisions or open questions that still need user confirmation
