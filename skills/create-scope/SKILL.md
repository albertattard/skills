---
name: create-scope
description: Use when a user proposes a product idea, project, feature, architecture, implementation plan, or ambiguous change and Codex should clarify the idea and create a clear scope before acting. The skill challenges vague assumptions, inspects available local context, asks option-based focussed questions when answers cannot be discovered, validates unclear answers, captures material clarifications, and continues until the problem, first user, first useful flow, trade-offs, risks, constraints, decisions, and next actions are clear enough to proceed.
---

# Create Scope

## Overview

Create enough shared understanding to define a scope and act deliberately. Prefer discovering answers from the repository or provided materials before asking the user, then challenge ambiguity with direct, focussed questions. Do not stop after the first clarification if material ambiguity remains.

## Workflow

1. Restate the proposed work in concrete terms.
2. Run the idea-readiness gate before writing scope:
   - product intent, stated as one concise paragraph
   - problem being solved
   - first user or beneficiary
   - desired outcome
   - the first useful flow that would prove value
   - major assumptions or unresolved decisions
3. Define the product intent as one concise paragraph in the scope output.
4. Identify assumptions, missing decisions, and terms that could mean more than one thing. Maintain these as an open-question list while scoping.
5. Define Out of Scope as relevant work that may belong to the product later but is deferred from the current scope.
6. Create a Not List for adjacent ideas that may appear to fit the product but are explicitly not part of what this product or solution is.
7. Capture trade-offs as ranked decision priorities that can guide later choices, for example user clarity > small scope > polish > extensibility.
8. Capture risks that could break the user experience, invalidate the scope, or cause scope expansion.
9. Inspect local context when it can answer a question: files, docs, existing code, git state, configs, scripts, and tests.
10. When scoping settles or exposes a durable architecture choice, record it as an ADR candidate in `Decisions` or `Open Questions` instead of burying it in prose. Use `$capture-architecture-decisions` when the user asks to capture ADRs or when the current task is explicitly architecture decision capture.
11. Ask exactly one question at a time when the answer cannot be determined safely. Include recommended options for the user to choose from.
12. After each answer, update the open-question list and decide whether the scope is ready, another clarification is required, or a decision should be explicitly deferred.
13. If the answer is unclear, contradictory, too broad, or does not follow the repository's conventions, warn the user, explain the risk, propose a clear interpretation, and ask for confirmation before using it.
14. Record material confirmed answers in the scope document's `Clarification Log`.
15. Push back when a request is too broad, contradictory, premature, not ready for scoping, or not yet tied to a user outcome.
16. Continue until no material open questions remain, the user explicitly defers the remaining questions, or the user explicitly stops.

## Domain Language

When a domain-significant term affects product behaviour, user experience, domain rules, data meaning, acceptance criteria, or implementation naming, keep the ubiquitous language current.

- If the term is clear and important, add or update it in `docs/domain/ubiquitous-language.md`.
- If the term is ambiguous, record the ambiguity as an open question in the relevant product artefact.
- If creating a new documentation directory or Markdown file, keep the corresponding `README.md` index current.

## Source Documents

Treat product descriptions, prompts, issues, and other source artefacts as inputs. Do not edit them while creating scope.

If clarification changes or contradicts a source artefact, record the clarified understanding in the scope document's `Source Clarifications` section instead of modifying the input document.

Use `None.` for `Source Clarifications` when the source artefact does not need correction, contradiction handling, or interpretation notes.

## Question Style

Ask questions that change the plan. Avoid asking for preferences that can be inferred from the codebase or chosen conservatively.

Each clarification question must:

- ask one decision at a time
- provide two to four recommended options with a short explanation of the trade-off
- identify the recommended option first when one option is clearly safer or more consistent with the repository
- allow the user to provide a different answer
- state what will be assumed if the user chooses an option

Use this format:

```markdown
Question: Which user should the MVP optimise for first?

Recommended options:

1. Internal operations user (recommended) - keeps the first workflow narrow and easy to validate.
2. External customer - proves customer value earlier but requires more polish and edge-case handling.
3. Administrator - focuses on setup and governance before the main user workflow.

You can choose one of these or provide a different answer.
```

When the user gives a free-form answer, validate it before applying it:

- If it is clear and compatible with the project, restate it briefly and continue.
- If it is ambiguous, ask a follow-up question with options.
- If it conflicts with known repository conventions, domain language, constraints, or earlier answers, warn the user and ask whether to use it anyway.
- If it introduces new scope, identify the expansion and ask whether it belongs in scope, out of scope, or the Not List.

If the user asks whether open questions remain, answer with the current open-question list and continue with the next highest-impact question. Do not merely say that open questions exist.

## Clarification Log

Capture material questions asked during scoping and the confirmed answers that shaped the scope. The log explains how ambiguity was resolved; it is not a raw transcript.

By default, keep the clarification log in the scope document after `Source Clarifications` and before `Intent`. Move it to a separate linked file, such as `docs/scopes/mvp-scope-clarifications.md`, only when the log is long, sensitive, audit-heavy, or would make the main scope hard to review.

Include only clarifications that affect scope, trade-offs, risks, domain language, exclusions, assumptions, constraints, or implementation direction. Omit trivial questions and intermediate answers that were replaced before confirmation.

Each entry should capture:

- the material question
- the confirmed answer
- the impact on scope, risk, trade-offs, domain language, or implementation direction

Use this format:

```markdown
- Question: Which user should the first version optimise for?
  Answer: Internal support staff.
  Impact: Limits the MVP to internal workflows and defers customer-facing polish.
```

If the user confirms an answer after being warned that it conflicts with conventions, constraints, or earlier decisions, record that confirmation in the impact.

Good questions:

- "Who is the first real user of this workflow?"
- "What is the first useful flow that would prove this feature is useful?"
- "Should this be optimised for local experimentation, production deployment, or both?"
- "What failure case must the first version handle?"
- "Which priority wins when user clarity, delivery speed, polish, and extensibility conflict?"

Poor questions:

- "What should I do next?"
- "Do you want this to be good?"
- "Which stack should I use?" when the repository already constrains the answer.

## Output

When enough clarity exists, summarise:

- the agreed goal
- the product intent
- the current constraints
- the first useful flow
- the trade-offs and risks captured
- the decisions made
- the material clarifications captured
- any domain language updates or unresolved term ambiguities
- the next concrete action

Do not create or finalise the scope document while material open questions remain unless the user explicitly chooses to defer them. Deferred questions must appear in the scope document's `Open Questions` section with the reason they were deferred.

## Out of Scope

Explicitly capture relevant product work that is deliberately deferred from the current scope.

Use Out of Scope for features, workflows, user groups, platforms, integrations, operational responsibilities, quality levels, or technical capabilities that may be useful for this product later but should not be built now.

## Not List

Explicitly capture what this product or solution is not, even when those ideas appear adjacent, useful, or superficially aligned.

Use the Not List to protect product identity and prevent category drift. Include adjacent product categories, solution types, audiences, responsibilities, operating models, or capabilities that should not become part of this product.

Do not treat Not List items as deferred backlog. Revisit them only if the product direction changes.

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

## Source Clarifications

None.

## Clarification Log

None.

## Intent

One concise paragraph describing the product outcome.

## Goal

## Target User

## First Useful Flow

## In Scope

## Out of Scope

## Not List

## Trade-Offs

## Risks

## Decisions

## Open Questions

## Next Step
```

If implementation should start immediately, state the first task and proceed.
