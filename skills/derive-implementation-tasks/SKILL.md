---
name: derive-implementation-tasks
description: Use when Codex needs to convert vertical slices, a path-to-production plan, and repository context into ordered implementation task Markdown files. The skill derives small, independently grabbable tasks, preserves traceability to slices and production-readiness work, distinguishes product work from release-readiness work, records dependencies and readiness, and avoids publishing remote tracker issues unless explicitly asked.
---

# Derive Implementation Tasks

## Overview

Turn vertical slices and production-readiness planning into concrete implementation tasks that a developer or coding agent can pick up one at a time.

Prefer executable task planning over generic issue generation. Each task should explain the observable behaviour or release-readiness outcome it delivers, how to validate it, what blocks it, and whether it is ready to implement.

## Inputs

Start from the most specific delivery artefacts available:

- `docs/slices/*.md`
- `docs/production/*.md`
- `docs/adrs/*.md`
- `docs/requirements/*.md`
- `docs/scopes/*.md`
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

## Workflow

1. Restate the first releasable increment from the slice sequence and path-to-production plan.
2. Inspect repository context for implementation boundaries, test commands, delivery conventions, and existing task or issue formats.
3. Inspect ADRs under `docs/adrs/` and treat accepted or proposed architecture decisions as implementation constraints.
4. Derive ordered tasks from vertical slices first, keeping each task tied to a user-visible or independently verifiable outcome.
5. Add production-readiness tasks only when they are required by the path-to-production plan for the first releasable increment.
6. Reference ADRs in a task only when they materially affect that task's scope, dependencies, acceptance criteria, validation, or implementation constraints.
7. Keep tasks independently grabbable: one task should be small enough for one developer or agent to implement without owning unrelated future scope.
8. Avoid horizontal task breakdowns such as "build UI", "add data model", "wire API", or "write tests" unless the task is clearly tied to a slice outcome or release-readiness gate.
9. Record dependencies explicitly. If a task cannot start until another task lands, mark it as blocked instead of hiding the ordering in prose.
10. Mark each task with a clear readiness value:
   - `ready-for-agent`: enough context exists for a developer or coding agent to implement it.
   - `needs-human-decision`: blocked by product, release, security, data, ownership, or operational ambiguity.
   - `blocked-by-task`: cannot start until another generated task is complete.
   - `manual-only`: requires credentials, access, deployment approval, production operation, or external-system action.
11. Assign each task to a capability area. Prefer product or domain capabilities such as `user-management`, `request-review`, `reporting`, or `notifications`. Use technical capability areas such as `infrastructure`, `deployment`, or `observability` only when the work does not naturally belong to one product capability or is shared across multiple capabilities.
12. Keep task files in one ordered sequence by default. Use the task index to provide grouped views by capability area, source slice or production workstream, type, and readiness.
13. Choose the task index structure based on expected growth, not only the current task count. If the source artefacts imply the task set may grow large, start with capability, source, type, and readiness groupings even when the initial task set is small.
14. Add capability sub-index files under `docs/tasks/capabilities/` when the main index becomes hard to scan or when the project already has clear capability areas. Capability sub-indexes are additive navigation aids; do not move or renumber existing task files to introduce them.
15. Use `decision` tasks for unresolved choices that block implementation. When the choice is architecture-significant, make the task outcome an ADR created with `$capture-architecture-decisions`, not just a prose answer in the task file.
16. Ask the user before writing files when task granularity, release boundaries, missing decisions, tracker format, capability grouping, or remote issue publication materially changes the plan and the user has not asked to proceed with assumptions.
17. When running non-interactively or when the user asks to avoid follow-up questions, choose the smallest conservative task breakdown that fits the source artefacts and repository context, then record assumptions and unresolved decisions in the affected tasks.
18. Use `TASK-NNNN` as the task number, where `NNNN` is a zero-padded sequence number.
19. Use the full `TASK-NNNN` identifier everywhere the task is referenced: filename, title, task index, dependency links, capability indexes, and final summaries.
20. Write or update task files under `docs/tasks/`, and keep the directory `README.md` current when files are added, moved, or deleted.

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
```

Adjust source links to match the actual input paths.

For small task sets that are expected to stay small, omit empty grouping sections when a flat sequence is easier to scan. For task sets that are expected to grow, include the grouped views from the start so future additions do not require a structural rewrite.

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

## Validation

- List expected test, build, lint, smoke check, manual check, or deployment check commands.

## Notes

- Capture assumptions, contradictions, sequencing notes, or implementation constraints that do not fit the sections above.
```

Use `depends_on: []` when the task can start immediately. Use empty arrays (`[]`) for `related_sources` or `related_adrs` when there are no relevant links.

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
- records dependencies and readiness honestly
- includes observable, verifiable acceptance criteria and validation steps
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
- requires unrelated future product scope to be useful
- creates remote tracker issues without explicit user approval
- says "write tests" without tying the tests to observable behaviour or a release gate

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
