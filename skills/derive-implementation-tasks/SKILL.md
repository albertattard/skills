---
name: derive-implementation-tasks
description: Use when Codex needs to convert vertical slices, a path-to-production plan, and repository context into ordered implementation task Markdown files. The skill derives small, independently grabbable tasks, preserves traceability to slices and production-readiness work, distinguishes product work from release-readiness work, records dependencies and readiness, and avoids publishing remote tracker issues unless explicitly asked.
---

# Derive Implementation Tasks

## Overview

Turn vertical slices and production-readiness planning into concrete implementation tasks that a developer or coding agent can pick up one at a time.

Prefer executable task planning over generic issue generation. Each task should explain the observable behaviour or release-readiness outcome it delivers, how to validate it, what blocks it, and whether it is ready to implement.

## Hard Rules

- Do not write or finalise task files until the task readiness check reaches `Ready to write implementation tasks`.
- Ask the user before writing files in interactive runs when task granularity, release boundary, source coverage, ADR constraints, validation expectations, dependency ordering, capability grouping, tracker format, or remote issue publication materially changes the task plan.
- Choose conservative assumptions only when the user or runbook explicitly asks to avoid follow-up questions.
- Do not mark a task `ready-for-agent` when a required product, release, security, data, ownership, operational, or architecture decision is still unresolved.
- Do not create remote GitHub, Jira, Linear, or other tracker issues unless the user explicitly asks for remote issue creation.

## Inputs

Start from the most specific delivery artefacts available:

- `docs/slices/*.md`
- `docs/production/*.md`
- `docs/adrs/*.md`
- `docs/requirements/*.md`
- `docs/scopes/*.md`
- shared profile index at `../shared/profiles/README.md`, when present
- user-provided task planning notes, capability or release grouping notes, or tracker conventions

Inspect repository context when it clarifies implementation work:

- existing source layout and module boundaries
- build, test, lint, and package scripts
- CI/CD and deployment files
- test conventions and fixtures
- migration, seed, data, configuration, and environment conventions
- existing issue or task templates

Treat scope, PRD, slice, production, and ADR documents as source artefacts. Do not edit them while deriving tasks.

If source assumptions, contradictions, or missing decisions affect task readiness, record them in the task files or final summary instead of modifying source artefacts.

## Task Readiness Check

Before writing or finalising task files, check whether the source artefacts and repository context are clear enough to derive implementation tasks.

Confirm that:

- the first releasable increment and release boundary are clear
- source coverage is clear: slices, production plan, ADRs, requirements, and repository context have been inspected as needed
- task granularity is clear enough to produce independently grabbable tasks
- capability grouping is clear enough for the expected task-set size
- accepted or proposed ADRs are mapped only to tasks they materially constrain
- product tasks and production-readiness tasks are separated without losing release sequence
- validation expectations are clear enough to make tasks verifiable
- browser-level validation setup is placed early enough to influence UI structure, routing, selectors, testability, and technology choices when browser validation is selected by ADRs, the path-to-production plan, repository conventions, or user instructions
- dependency ordering uses the narrowest real blockers rather than the full release sequence, so tasks that can run in parallel are not artificially serialised
- selected shared profiles are applied consistently when accepted ADRs, repository instructions, user instructions, or existing repository conventions clearly match one available profile
- unresolved decisions are represented as `decision` tasks or open decisions rather than hidden inside ready tasks
- remote tracker publication is explicitly requested if any remote issue creation is expected

If a material task-planning question remains in an interactive run, ask the highest-impact question first using the question style below. Ask one question per turn. After the user answers, validate the answer, update the readiness check, and either ask the next highest-impact question or state `Ready to write implementation tasks`.

If the user or runbook explicitly asks to avoid follow-up questions, choose the smallest conservative task breakdown that fits the source artefacts and repository context. Record assumptions and unresolved decisions in the affected tasks and in the task index `Open Decisions` section when they affect task readiness or sequencing.

If the answer is unclear, contradictory, too broad, or conflicts with source artefacts, ADRs, repository conventions, or earlier answers, warn the user, propose a clear interpretation, and ask for confirmation before using it.

## Question Style

Ask questions that change the implementation task plan. Avoid asking for preferences that can be inferred from source artefacts, repository context, ADRs, or conservative task-planning assumptions when the user has asked to avoid follow-up questions.

Each task-planning question must:

- ask one planning decision at a time
- provide two to four recommended options with a short explanation of the trade-off
- identify the recommended option first when one option is clearly safer or more consistent with the source artefacts
- allow the user to provide a different answer
- state what will be assumed if the user chooses an option

Use this format:

```markdown
Question: What task granularity should the first implementation plan use?

Recommended options:

1. Small independently grabbable tasks (recommended) - lets agents implement and verify one observable outcome at a time.
2. Larger slice-sized tasks - keeps fewer files but may make each task too broad for one agent.
3. Fine-grained technical tasks - gives detailed sequencing but risks splitting work by technical layer instead of user value.

You can choose one of these or provide a different answer.
```

For capability grouping:

```markdown
Question: How should implementation tasks be grouped for navigation?

Recommended options:

1. Product or domain capability areas (recommended) - keeps tasks organised around user and domain outcomes.
2. Release workstreams - emphasises production-readiness sequencing but may obscure product capability ownership.
3. Flat ordered sequence only - keeps the first task set simple but may become hard to scan as the task count grows.

You can choose one of these or provide a different answer.
```

For remote tracker publication:

```markdown
Question: Should the task plan create remote tracker issues?

Recommended options:

1. Local Markdown task files only (recommended) - keeps the workflow reproducible and avoids external tracker access requirements.
2. Prepare tracker-ready Markdown only - lets humans copy tasks later without granting tool access.
3. Create remote tracker issues now - publishes tasks immediately but requires explicit tracker, project, and credential decisions.

You can choose one of these or provide a different answer.
```

For browser-test harness timing:

```markdown
Question: When should browser-level validation be introduced?

Recommended options:

1. Immediately after the runnable application foundation (recommended) - lets the test harness influence routing, page structure, selectors, and technology choices before product slices accumulate.
2. In the first user-facing product task - avoids an extra early task but may mix test-harness setup with product behaviour.
3. Near release verification - keeps early tasks smaller but risks discovering testability and stack issues late.

You can choose one of these or provide a different answer.
```

Do not force numbered options for factual values such as a project key, repository URL, tracker board id, credential name, environment name, or command name. Ask for the value directly when that exact value is required.

When the user gives a free-form answer, validate it before applying it:

- If it is clear and compatible with the source artefacts, ADRs, and repository context, restate it briefly and continue.
- If it is ambiguous, ask a follow-up question with options when it is a planning decision, or ask for the missing factual value when it is not.
- If it conflicts with source decisions, ADRs, repository conventions, release constraints, or earlier answers, warn the user and ask whether to use it anyway.
- If it introduces new product or release scope, identify the expansion and ask whether it belongs in the task plan, future work, or open decisions.

## Workflow

1. Restate the first releasable increment from the slice sequence and path-to-production plan.
2. Inspect repository context for implementation boundaries, test commands, delivery conventions, and existing task or issue formats.
3. Inspect ADRs under `docs/adrs/` and treat accepted or proposed architecture decisions as implementation constraints.
4. Inspect `../shared/profiles/README.md` when it exists. Use it only to identify available profile ids selected by repository instructions, accepted ADRs, user instructions, or existing repository conventions. Do not use shared profiles as a fallback stack decision.
5. Derive ordered tasks from vertical slices first, keeping each task tied to a user-visible or independently verifiable outcome.
6. Add production-readiness tasks only when they are required by the path-to-production plan for the first releasable increment.
7. Reference ADRs in a task only when they materially affect that task's scope, dependencies, acceptance criteria, validation, implementation constraints, or selected `default_profile`.
8. Keep tasks independently grabbable: one task should be small enough for one developer or agent to implement without owning unrelated future scope.
9. Avoid horizontal task breakdowns such as "build UI", "add data model", "wire API", or "write tests" unless the task is clearly tied to a slice outcome or release-readiness gate.
10. For tasks with a user-facing UI deliverable, ensure the result is not just functional but visually intentional. Do not rely on default or bare styling. Apply basic layout, spacing, typography, readable colours, and responsive behaviour so the interface is coherent and usable. Simplicity is fine, but unstyled or visually incoherent output is not acceptable unless styling is explicitly out of scope.
11. When browser-level validation is selected by ADRs, the path-to-production plan, repository conventions, or user instructions, derive an early browser-test harness task as soon as there is a runnable application foundation. Do not defer browser-test setup to final release verification when earlier setup can influence UI structure, routing, selectors, accessibility hooks, testability, or technology choices.
12. Keep the early browser-test harness task small. It should establish the tool, test command integration, application startup strategy, browser prerequisites, a minimal smoke test against the runnable shell or first page, and conventions for selectors or page objects. It should not try to cover the full product workflow before the workflow exists.
13. For each later user-facing product task, include validation guidance to extend the existing browser-test harness for that task's observable behaviour when a practical browser path exists.
14. Keep a later release-flow verification task when the path-to-production plan requires a complete release gate. That later task should confirm the end-to-end workflow and release command integration, not introduce the browser-test stack for the first time unless no earlier browser validation was selected.
15. For browser-level validation tasks that cover multi-step user flows, include acceptance criteria or notes requiring a small domain-specific fluent driver or page object unless the flow is trivial or the repository already has a different browser-test convention.
16. Add a `default_profile` front matter field only when repository instructions, accepted ADRs, user instructions, or existing repository conventions explicitly select one available shared profile. Apply the selected profile consistently to tasks that will implement code in that stack. Do not invent a stack profile from product requirements alone.
17. Record dependencies explicitly. Use the narrowest real blocker for each task, not merely the previous task in the release sequence. A task should depend only on work, decisions, access, generated files, or validation infrastructure it actually needs before it can start.
18. Prefer parallelisable dependency graphs for independent product capabilities. For example, if preparation tracking and agenda reordering both require workshop context but do not require each other, both should depend on the context task rather than being chained together.
19. Preserve the recommended release sequence in the task index even when dependency edges allow parallel implementation.
20. If a task cannot start until another task lands, mark it as blocked instead of hiding the ordering in prose.
21. Mark each task with a clear readiness value:
   - `ready-for-agent`: enough context exists for a developer or coding agent to implement it.
   - `needs-human-decision`: blocked by product, release, security, data, ownership, or operational ambiguity.
   - `blocked-by-task`: cannot start until another generated task is complete.
   - `manual-only`: requires credentials, access, deployment approval, production operation, or external-system action.
22. Assign each task to a capability area. Prefer product or domain capabilities such as `user-management`, `request-review`, `reporting`, or `notifications`. Use technical capability areas such as `infrastructure`, `deployment`, or `observability` only when the work does not naturally belong to one product capability or is shared across multiple capabilities.
23. Keep task files in one ordered sequence by default. Use the task index to provide grouped views by capability area, source slice or production workstream, type, and readiness.
24. Choose the task index structure based on expected growth, not only the current task count. If the source artefacts imply the task set may grow large, start with capability, source, type, and readiness groupings even when the initial task set is small.
25. Add capability sub-index files under `docs/tasks/capabilities/` when the main index becomes hard to scan or when the project already has clear capability areas. Capability sub-indexes are additive navigation aids; do not move or renumber existing task files to introduce them.
26. Use `decision` tasks for unresolved choices that block implementation. When the choice is architecture-significant, make the task outcome an ADR created with `$capture-architecture-decisions`, not just a prose answer in the task file.
27. Run the task readiness check before writing files.
28. Use `TASK-NNNN` as the task number, where `NNNN` is a zero-padded sequence number.
29. Use the full `TASK-NNNN` identifier everywhere the task is referenced: filename, title, task index, dependency links, capability indexes, and final summaries.
30. Write or update task files under `docs/tasks/`, and keep the directory `README.md` current when files are added, moved, or deleted.

Do not create remote GitHub, Jira, Linear, or other tracker issues unless the user explicitly asks for remote issue creation.

## File Naming

Use the next available sequence number:

```text
docs/tasks/TASK-0001-submit-first-request.md
docs/tasks/TASK-0002-add-request-status-review.md
```

Do not renumber existing tasks. When updating existing bare-numeric task files, preserve their numeric sequence and rename only to add the `TASK-` prefix when references can be updated. Do not use bare numeric identifiers such as `0001` for tasks; use the full `TASK-0001` form everywhere.

Keep each file focused on one implementation task.

Do not place task files in type-based folders such as `docs/tasks/product/` or `docs/tasks/validation/`. Type and readiness can change; the release sequence should remain stable.

## Task Index Template

Use this structure for `docs/tasks/README.md`:

```markdown
# Implementation Tasks

## Source

Derived from:

- [vertical slices](../slices/README.md)
- [path to production](../production/path-to-production.md)
- [architecture decision records](../adrs/README.md)

## Clarification Log

None.

## Task Sequence

| Task | Status | Type | Readiness | Depends On |
| --- | --- | --- | --- | --- |
| [TASK-0001. Task title](TASK-0001-task-title.md) | todo | product | ready-for-agent | None |

## By Capability Area

### Capability Name

- [TASK-0001. Task title](TASK-0001-task-title.md)

## By Source

### Slice or Production Workstream

- [TASK-0001. Task title](TASK-0001-task-title.md)

## By Type

### Product

- [TASK-0001. Task title](TASK-0001-task-title.md)

### Production Readiness

### Validation

### Decision

### Manual Operation

## By Readiness

### Ready for Agent

- [TASK-0001. Task title](TASK-0001-task-title.md)

### Needs Human Decision

### Blocked By Task

### Manual Only

## Open Decisions

- List unresolved decisions that affect task readiness or sequencing.

## Future Decisions

- List deliberate future choices that are out of scope for the first release and do not block the current task sequence.
```

Adjust source links to match the actual input paths.

Keep `Open Decisions` limited to decisions that block, change, or materially affect implementation, readiness, validation, or sequencing for the current release. Put deliberately excluded future scope in `Future Decisions` instead. Do not write `None.` and then list decisions under the same heading.

For small task sets that are expected to stay small, omit empty grouping sections when a flat sequence is easier to scan. For task sets that are expected to grow, include the grouped views from the start so future additions do not require a structural rewrite.

## Clarification Log

Capture material questions asked while deriving implementation tasks and the confirmed answers that shaped the task plan. The log explains how task-planning ambiguity was resolved; it is not a raw transcript.

Include only clarifications that affect task granularity, release boundary, first implementation task, capability grouping, dependency sequencing, readiness values, validation expectations, browser-test harness timing, ADR mapping, remote tracker publication, or open decisions. Omit trivial questions and intermediate answers that were replaced before confirmation.

Each entry should capture:

- the material question
- the confirmed answer
- how the answer shaped the task plan

Use this format:

```markdown
- Question: What task granularity should the first implementation plan use?
  Answer: Small independently grabbable tasks.
  Impact: Tasks are split around one observable product or release-readiness outcome and avoid broad slice-sized work items.
```

Use `None.` when no clarification was needed.

## Capability Index Template

When capability sub-indexes are useful, use this structure for each file under `docs/tasks/capabilities/`:

```markdown
# Capability Name

## Goal

Describe the product, domain, or shared technical capability this group covers.

## Tasks

| Task | Status | Type | Readiness | Depends On |
| --- | --- | --- | --- | --- |
| [TASK-0001. Task title](../TASK-0001-task-title.md) | todo | product | ready-for-agent | None |

## Exit Criteria

- List the observable criteria that prove this capability area has enough implementation coverage for the current release.

## Open Decisions

- List unresolved decisions that affect this capability area.

## Future Decisions

- List deliberate future choices that are out of scope for this capability area in the current release.
```

Capability files are navigation aids, not task containers. Do not move task files into capability folders.

## Task Template

Use this structure for each task file:

```markdown
---
id: TASK-NNNN
title: Task Title
status: todo
type: product | production-readiness | validation | decision | manual-operation
capability_area: user-management
readiness: ready-for-agent | needs-human-decision | blocked-by-task | manual-only
default_profile: null
depends_on: []
related_sources:
  - SLICE-0001
  - docs/production/path-to-production.md
related_adrs:
  - ADR-0001
---

## Summary

Describe the observable product behaviour or release-readiness result in one or two sentences. Mention the source slice, production workstream, or ADR when that context is needed to understand the task.

## Scope

- List the implementation work included in this task.

## Excludes

- List tempting work that should remain out of this task.

## Dependencies

- List generated task files, external decisions, access requirements, or repository prerequisites that block this task.

## Acceptance Criteria

- Use observable and verifiable criteria that can be manually checked, tested, or evidenced by documented output. Use measurable thresholds only when they clarify behaviour or readiness; do not invent fake precision.
- For user-facing screens, include criteria for deliberate visual presentation, readable layout, usable forms or controls, and responsive behaviour at a basic desktop and narrow viewport size unless styling is explicitly out of scope.

## Validation

- List expected test, build, lint, smoke check, manual check, or deployment check commands.
- For tasks with a user-facing UI deliverable, include a visual browser check or screenshot review in addition to automated behavioural tests when the repository has a practical local browser path.
- For browser-level multi-step flows, state the expected test structure: scenario-style tests using a domain-specific fluent driver or page object that owns selectors, waits, repeated actions, and product-state assertions.

## Notes

- Capture assumptions, contradictions, sequencing notes, or implementation constraints that do not fit the sections above.
```

Use `depends_on: []` when the task can start immediately. Use empty arrays (`[]`) for `related_sources` or `related_adrs` when there are no relevant links.

Use `default_profile: null` when no profile is selected. Use a profile id such as `java-spring-server-rendered` only when that id exists in the shared profile index and is explicitly selected by repository instructions, accepted ADRs, user instructions, or existing repository conventions. When a selected profile applies to the application stack, apply it consistently to implementation and validation tasks that will edit or test that stack.

Use `status: todo` for newly generated tasks. Implementation agents may change it to `done` after the task's acceptance criteria and validation pass.

Omit `Notes` only when there is nothing useful to say.

Include ADRs only for tasks that are materially constrained by those ADRs.

Do not duplicate front matter fields as separate body sections. In particular, do not add separate `Type`, `Capability Area`, or `Readiness` sections unless the user explicitly asks for a non-front-matter format.

## Quality Bar

A good implementation task:

- traces back to a vertical slice, path-to-production workstream, validation gate, or recorded decision
- references relevant ADRs when architecture decisions constrain the work
- has one clear outcome and a bounded scope
- is independently grabbable by one developer or coding agent
- preserves vertical slice intent instead of splitting work by technical layer
- records minimal real dependencies and readiness honestly
- includes observable, verifiable acceptance criteria and validation steps
- sets a selected shared profile when accepted ADRs or repository conventions clearly match one
- makes tasks with a user-facing UI deliverable responsible for a simple coherent presentation instead of only DOM content
- captures material task-planning clarifications and their impact
- distinguishes product implementation from production-readiness, validation, decision, and manual-operation work

A good task index:

- preserves the full release sequence
- lets a reader find work by capability area, source slice, type, and readiness
- keeps task files in stable `TASK-NNNN` order
- uses capability sub-indexes when the task set is too large for one readable page

A poor implementation task:

- becomes a vague reminder or generic backlog item
- hides unresolved decisions behind implementation language
- duplicates another task's scope
- serialises independent product capabilities by depending on the previous task only because it appears earlier in the release sequence
- requires unrelated future product scope to be useful
- creates remote tracker issues without explicit user approval
- says "write tests" without tying the tests to observable behaviour or a release gate
- treats an unstyled browser-default page as done for a user-facing web application

A poor task index:

- forces readers to scan a 100-task flat list with no grouped views
- splits task files into type-based folders that obscure release sequence
- treats technical workstreams as product capabilities when the work clearly belongs to a user-facing capability
- duplicates task definitions across index files
- hides blocked or manual-only work among ready tasks

## Output

After creating or revising implementation tasks, summarise:

- task files created or changed
- the recommended first implementation task
- tasks that are ready for an agent or developer
- blocked, manual-only, or decision-dependent tasks
- assumptions or contradictions documented in the output
- any task sequencing or scope decisions that still need user confirmation
