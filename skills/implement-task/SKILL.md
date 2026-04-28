---
name: implement-task
description: Use when Codex needs to implement one existing implementation task from docs/tasks/. The skill verifies task readiness and dependencies, keeps work scoped to the selected task, prefers coarse behavioral or integration tests tied to acceptance criteria, applies a red-green-refactor loop where useful, designs for low cognitive load and deep modules, runs validation, and reports test coverage, manual checks, blockers, and follow-up work.
---

# Implement Task

## Overview

Implement one existing task from `docs/tasks/` with disciplined scope control.

Prefer observable behaviour over internal activity. The implementation should satisfy the selected task's acceptance criteria, respect its dependencies and readiness state, and leave the codebase easier to understand than it was before.

This skill executes generated tasks. It does not derive, split, reorder, or publish tasks.

## Inputs

Start from a specific task file, usually one of:

- `docs/tasks/0001-task-title.md`
- a task linked from `docs/tasks/README.md`
- a user-provided task document that follows the implementation task structure

Read nearby context only when it affects the selected task:

- `docs/tasks/README.md`
- source slice, production, requirement, or scope documents linked by the task
- repository instructions such as `AGENTS.md`
- build, test, lint, package, migration, fixture, and deployment conventions
- existing tests that cover the affected behaviour
- relevant source files and module boundaries

Treat task, slice, production, requirement, and scope documents as source artefacts. Do not change them unless the selected task explicitly requires documentation updates or the task index must stay current after task-related file changes.

## Readiness Gate

Before editing code, inspect the selected task's `Readiness`, `Dependencies`, `Acceptance Criteria`, and `Validation` sections.

- `ready-for-agent`: proceed when dependencies are satisfied.
- `blocked-by-task`: stop unless the blocking task is already complete in the repository.
- `needs-human-decision`: stop and ask for the missing decision unless the user explicitly provided it.
- `manual-only`: do not implement as code; report the required manual action or evidence.

If the task file is missing readiness, dependencies, acceptance criteria, or validation guidance, infer the smallest useful interpretation from repository context. Record the assumption in the final summary instead of silently broadening the task.

Do not implement adjacent work merely because it is nearby. If the selected task is too broad, contradictory, or depends on unresolved product, data, security, or release decisions, challenge the task before editing.

## Implementation Workflow

1. Restate the selected task, outcome, readiness, dependencies, and acceptance criteria.
2. Inspect the repository enough to identify the affected module boundaries, existing patterns, and validation commands.
3. Choose the first observable behaviour or release-readiness outcome from the acceptance criteria.
4. Add or update a failing test before implementation when the behaviour can be tested locally and deterministically.
5. Implement the smallest coherent change that makes the test pass.
6. Repeat the behaviour-by-behaviour loop until the task's acceptance criteria are covered.
7. Refactor only while tests are green, and only to reduce real complexity, clarify boundaries, or align with established local patterns.
8. Run the task's validation commands and any focused tests needed for the touched area.
9. If implementation requires a new durable architecture decision, stop and challenge the task unless the decision is already captured in an ADR or the user explicitly asks to make and capture it. Use `$capture-architecture-decisions` for the ADR before or alongside the implementation work.
10. Report changed files, validation results, acceptance criteria covered by tests, manual checks performed or still required, and unresolved follow-up work.

When a test-first loop is not useful, explain why in the final summary. Examples include documentation-only work, manual operations, wiring that cannot run locally, or changes where the repository has no practical deterministic test surface.

## Testing Bias

Prefer fewer larger-scope tests over many narrow tests.

- Default to acceptance-level, integration-style, or feature-level tests that prove user-visible behaviour or release-readiness outcomes.
- Tie each test to one or more acceptance criteria from the selected task.
- Test through public interfaces, user flows, API boundaries, command output, persisted state, or documented operational evidence.
- Avoid tests that mostly mirror implementation details, private helpers, mocks, or internal call sequences.
- Add a smaller test only when it isolates a tricky rule, edge case, parser, calculation, permission check, migration, or regression that would be awkward, slow, brittle, or unclear through a broader test.
- Keep tests deterministic, local, and maintainable. Do not introduce slow, flaky, or external-service-dependent tests unless the repository already supports that pattern.

Use a red-green-refactor loop as a discipline, not as ceremony. One meaningful failing test per observable behaviour is usually better than many small tests that make the implementation harder to change.

## Design Bias

Prefer changes that reduce cognitive load for the next maintainer.

- Keep module interfaces small, explicit, and hard to misuse.
- Prefer deep modules: hide meaningful complexity behind simple APIs.
- Avoid shallow abstractions that mostly rename one operation, pass data through, or split code without creating a clearer boundary.
- Do not split code just to make files or functions smaller. Split when it creates a stable concept, clearer responsibility, or useful isolation.
- Keep task-specific decisions close to the task, but move stable domain rules into shared code when reuse is real.
- Prefer clear names that carry domain meaning over vague names such as `data`, `handler`, `manager`, `processor`, or `utils`.
- Make invalid states hard to represent when the language and local style support it.
- Preserve the repository's existing patterns unless they conflict with the selected task or create avoidable complexity.
- Use comments to explain intent, invariants, constraints, and non-obvious trade-offs. Do not narrate obvious code.

Before finishing, look for accidental complexity introduced by the change and simplify it while tests are green.

## Scope Control

Implement exactly one selected task.

Allowed supporting work:

- small refactors required to implement the task cleanly
- focused test fixtures or helpers needed by the task's tests
- documentation updates explicitly required by the task
- dependency or configuration changes required by the task and consistent with repository conventions

Out of scope unless explicitly requested:

- implementing later tasks
- publishing remote tracker issues
- broad architecture rewrites
- unrelated dependency upgrades
- speculative extensibility
- changing source product artefacts to make the task easier

If the task reveals a defect or missing decision outside its scope, document it as follow-up instead of absorbing it into the implementation.

## Design Self-Review

Before the final response, check:

- Did this change satisfy the selected task's acceptance criteria?
- Did tests cover the highest useful level that remains fast, deterministic, and maintainable?
- Did this change add a shallow abstraction?
- Did it expose implementation details through names, types, parameters, files, or module boundaries?
- Is there a simpler interface that would hide more complexity?
- Are important assumptions captured in code, tests, comments, or the final summary?
- Did this task introduce or change an architecture decision that should be captured in `docs/adr/`?
- Did the implementation avoid dragging in future scope?

Address issues found during the review when the fix is within the selected task and tests remain green.

## Output

After implementation, summarise:

- the task implemented
- files changed
- acceptance criteria covered by automated tests
- acceptance criteria covered by manual checks
- validation commands run and their results
- assumptions, blockers, or follow-up work that remain

If implementation did not proceed, summarise the readiness or dependency blocker and the smallest decision or prerequisite needed to continue.
