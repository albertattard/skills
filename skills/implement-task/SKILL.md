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

- `docs/tasks/TASK-0001-task-title.md`
- a task linked from `docs/tasks/README.md`
- a user-provided task document that follows the implementation task structure

Task files may store task metadata such as `id`, `title`, `status`, `type`, `capability_area`, `readiness`, `depends_on`, and related source references in YAML front matter instead of separate body sections.

Read nearby context only when it affects the selected task:

- `docs/tasks/README.md`
- source slice, production, requirement, or scope documents linked by the task
- repository instructions such as `AGENTS.md`
- build, test, lint, package, migration, fixture, and deployment conventions
- existing tests that cover the affected behaviour
- relevant source files and module boundaries

Treat task, slice, production, requirement, and scope documents as source artefacts. Do not change them unless the selected task explicitly requires documentation updates, the selected task's completion status must be updated, or the task index must stay current after task-related file changes.

## Preflight Gate

Before inspecting task readiness or editing code, verify that the repository is in a trustworthy baseline state.

1. Check the worktree status. If there are tracked or untracked non-ignored changes, stop and ask the user to commit, stash, discard, or otherwise handle them before implementation begins.
2. Identify the repository's compile, test, and functional-test validation commands from project documentation, task validation guidance, build files, scripts, or established local conventions.
3. Run the full baseline validation suite, including functional tests when the repository defines them. Do not proceed if compilation or tests fail, because later failures would be ambiguous between pre-existing defects and defects introduced by the selected task.

If the repository does not define a compile, test, or functional-test command, record that gap as an assumption in the final summary and run the strongest available baseline validation instead.

## Readiness Gate

Before editing code, inspect the selected task's status, readiness, dependencies, acceptance criteria, and validation guidance. Prefer YAML front matter fields such as `status`, `readiness`, and `depends_on` when present; otherwise use body sections such as `Readiness` and `Dependencies`.

- `done`: stop and report that the task is already complete.
- `ready-for-agent`: proceed when dependencies are satisfied.
- `blocked-by-task`: stop unless the blocking task is already complete in the repository.
- `needs-human-decision`: stop and ask for the missing decision unless the user explicitly provided it.
- `manual-only`: do not implement as code; report the required manual action or evidence.

If the task file is missing readiness, dependencies, acceptance criteria, or validation guidance in both front matter and body sections, infer the smallest useful interpretation from repository context. Record the assumption in the final summary instead of silently broadening the task.

Do not implement adjacent work merely because it is nearby. If the selected task is too broad, contradictory, or depends on unresolved product, data, security, or release decisions, challenge the task before editing.

## Implementation Workflow

1. Run the preflight gate and stop if the worktree is dirty or baseline validation fails.
2. Restate the selected task, outcome, readiness, dependencies, and acceptance criteria.
3. Inspect the repository enough to identify the affected module boundaries, existing patterns, and validation commands.
4. If implementation requires a new durable architecture decision, stop and challenge the task unless the decision is already captured in an ADR or the user explicitly asks to make and capture it. Use `$capture-architecture-decisions` for the ADR before or alongside the implementation work.
5. Choose the first observable behaviour or release-readiness outcome from the acceptance criteria.
6. Add or update a failing test before implementation when the behaviour can be tested locally and deterministically.
7. Implement the smallest coherent change that makes the test pass.
8. Repeat the behaviour-by-behaviour loop until the task's acceptance criteria are covered.
9. Refactor only while tests are green, and only to reduce real complexity, clarify boundaries, or align with established local patterns.
10. Run the task's validation commands, any focused tests needed for the touched area, and the full repository validation suite again, including functional tests when the repository defines them.
11. If all acceptance criteria are satisfied and validation passes, mark the selected task `status` as `done` and keep `docs/tasks/README.md` and capability indexes current. If completing this task clearly unblocks dependent generated tasks, update those tasks' readiness from `blocked-by-task` to `ready-for-agent` only when all their generated task dependencies are complete and no human, manual, product, security, data, or release decision still blocks them.
12. Report changed files, validation results, acceptance criteria covered by tests, manual checks performed or still required, task status/index updates, and unresolved follow-up work.

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

### Independent Confidence

Design tests so each test has a distinct reason to fail.

- Use overlap between test levels only when it buys different confidence. For example, one browser smoke test may cover the main user journey while focused controller, service, or domain tests cover edge cases and rules.
- Avoid repeating the same broad rendered-page assertions across many tests. If a copy, layout, or label change would break several tests without changing product behaviour, the tests are too coupled to presentation.
- Put business rules in the lowest useful test level that still proves the behaviour clearly. Use domain or service tests for calculations, state transitions, ordering, normalization, and validation rules when those rules can be exercised without a browser or full rendered page.
- Use browser tests for integration risks: real navigation, form wiring, client-visible state, accessibility roles, critical happy paths, and cross-screen flows.
- Use controller or MVC tests for request handling, validation feedback, route guards, rendered empty states, and security or read-only constraints.
- In browser and MVC tests, assert stable user-observable outcomes rather than every repeated text string on the page.
- Prefer one expressive scenario assertion over many incidental assertions. A test should fail because the behaviour it names is broken, not because nearby page content changed.

For browser-level tests that cover multi-step user flows, prefer a small domain-specific fluent driver or page object by default. The test should read like a scenario script, while the driver owns Playwright selectors, waits, repeated interactions, and product-state assertions. Name driver methods after user actions and observable product states, not DOM operations. Keep fluent driver assertions focused on named product states; avoid `assertPageIsCorrect`-style helpers that assert incidental page content. Keep the driver small at first, and split it by screen or workflow only when one class starts mixing unrelated responsibilities.

## Design Bias

Prefer changes that reduce cognitive load for the next maintainer.

- Keep module interfaces small, explicit, and hard to misuse.
- Prefer deep modules: hide meaningful complexity behind simple APIs.
- Avoid shallow abstractions that mostly rename one operation, pass data through, or split code without creating a clearer boundary.
- Do not split code just to make files or functions smaller. Split when it creates a stable concept, clearer responsibility, or useful isolation.
- Keep task-specific decisions close to the task, but move stable domain rules into shared code when reuse is real.
- Prefer clear names that carry domain meaning over vague names such as `data`, `handler`, `manager`, `processor`, or `utils`.
- Make invalid states hard to represent when the language and local style support it.
- Mark methods `static` when they do not read or mutate instance state and the language or local style supports it. This is especially useful for pure formatting, parsing, comparison, mapping, and small calculations that only use their parameters. Do not make methods static when they are part of an object's polymorphic contract, need instance collaborators, or would make the API harder to test or evolve.
- Preserve the repository's existing patterns unless they conflict with the selected task or create avoidable complexity.
- When creating new framework configuration and no repository convention exists, prefer structured configuration formats that preserve hierarchy clearly, such as YAML instead of properties. For Spring Boot applications, prefer `application.yml` over `application.properties` unless the repository already uses properties files.
- Use comments to explain intent, invariants, constraints, and non-obvious trade-offs. Do not narrate obvious code.

Before finishing, look for accidental complexity introduced by the change and simplify it while tests are green.

## User Interface Bias

When the selected task includes user-facing UI work, implement it modestly but intentionally.

- Follow the task's UI acceptance criteria and validation guidance before adding broader polish.
- Use the domain workflow to shape layout: put the primary action, current state, and next useful input where the user can scan them without reading instructions.
- Prefer shared styles, an existing design system, or established local components over page-specific styling when more than one screen shares the same application shell.
- Keep typography, spacing, colours, forms, buttons, status messages, empty states, and responsive behaviour consistent enough for repeated use.
- Do not rely on browser-default foreground and background colours for user-facing screens.
- Add automated assertions for durable UI contracts when practical, but do not treat text-only assertions as proof of visual quality.
- Perform a manual browser or screenshot check for new or substantially changed screens when a local browser path is available, and record that check in the final summary.

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
- Did this task introduce or change an architecture decision that should be captured in `docs/adrs/`?
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
