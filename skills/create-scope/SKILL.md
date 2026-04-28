---
name: create-scope
description: Use when a user proposes a product idea, project, feature, architecture, implementation plan, or ambiguous change and Codex should clarify the idea and create a clear scope before acting. The skill challenges vague assumptions, inspects available local context, asks one focussed question at a time when answers cannot be discovered, and continues until the problem, first user, smallest useful behaviour, trade-offs, risks, constraints, decisions, and next actions are clear enough to proceed.
---

# Create Scope

## Overview

Create enough shared understanding to define a scope and act deliberately. Prefer discovering answers from the repository or provided materials before asking the user, then challenge ambiguity with direct, focussed questions.

## Workflow

1. Restate the proposed work in concrete terms.
2. Run the idea-readiness gate before writing scope:
  - problem being solved
  - first user or beneficiary
  - desired outcome
  - smallest useful behaviour that would prove value
  - major assumptions or unresolved decisions
3. Check whether the clarified intent changes the product description. If it does, update the relevant product description artefact before or alongside the scope.
4. Identify assumptions, missing decisions, and terms that could mean more than one thing.
5. Capture trade-offs as ranked decision priorities that can guide later choices, for example learning clarity > small scope > polish > extensibility.
6. Capture risks that could break the user experience, invalidate the scope, or cause scope expansion.
7. Inspect local context when it can answer a question: files, docs, existing code, git state, configs, scripts, and tests.
8. Ask exactly one question at a time when the answer cannot be determined safely.
9. Push back when a request is too broad, contradictory, premature, not ready for scoping, or not yet tied to a user outcome.
10. Continue until the next action is clear enough to execute or the user explicitly stops.

## Domain Language

When a domain-significant term affects product behaviour, user experience, domain rules, data meaning, acceptance criteria, or implementation naming, keep the ubiquitous language current.

- If the term is clear and important, add or update it in `docs/domain/ubiquitous-language.md`.
- If the term is ambiguous, record the ambiguity as an open question in the relevant product artefact.
- If creating a new documentation directory or Markdown file, keep the corresponding `README.md` index current.

## Question Style

Ask questions that change the plan. Avoid asking for preferences that can be inferred from the codebase or chosen conservatively.

Good questions:

- "Who is the first real user of this workflow?"
- "What is the smallest behaviour that would prove this feature is useful?"
- "Should this be optimised for local learning, production deployment, or both?"
- "What failure case must the first version handle?"
- "Which priority wins when learning clarity, delivery speed, polish, and extensibility conflict?"

Poor questions:

- "What should I do next?"
- "Do you want this to be good?"
- "Which stack should I use?" when the repository already constrains the answer.

## Output

When enough clarity exists, summarise:

- the agreed goal
- the current constraints
- the smallest useful behaviour
- the trade-offs and risks captured
- the decisions made
- any domain language updates or unresolved term ambiguities
- the next concrete action

## Scope Documents

For product, project, or feature scoping work, create or update the scope artefact once enough clarity exists unless the user explicitly asks for discussion only. Write scope documents under `docs/scopes/`.

Use a focussed, kebab-case filename:

```text
docs/scopes/mvp-scope.md
docs/scopes/v2-feature-scope.md
```

Include a `Source` section that links to the product description, prompt, issue, or other artefact used as input. Adjust the relative link to match the actual output path.

Use this structure:

```markdown
# Scope

## Source

Derived from:

- [product description](../product/description.md)

## Goal

## Target User

## Smallest Useful Behaviour

## In Scope

## Out Of Scope

## Trade-Offs

## Risks

## Decisions

## Open Questions

## Next Step
```

If implementation should start immediately, state the first task and proceed.
