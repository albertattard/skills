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

Treat scope, PRD, slice, and production documents as source artefacts. Do not edit them while deriving tasks.

If source assumptions, contradictions, or missing decisions affect task readiness, record them in the task files or final summary instead of modifying source artefacts.

## Workflow

1. Restate the first releasable increment from the slice sequence and path-to-production plan.
2. Inspect repository context for implementation boundaries, test commands, delivery conventions, and existing task or issue formats.
3. Derive ordered tasks from vertical slices first, keeping each task tied to a user-visible or independently verifiable outcome.
4. Add production-readiness tasks only when they are required by the path-to-production plan for the first releasable increment.
5. Keep tasks independently grabbable: one task should be small enough for one developer or agent to implement without owning unrelated future scope.
6. Avoid horizontal task breakdowns such as "build UI", "add data model", "wire API", or "write tests" unless the task is clearly tied to a slice outcome or release-readiness gate.
7. Record dependencies explicitly. If a task cannot start until another task lands, mark it as blocked instead of hiding the ordering in prose.
8. Mark each task with a clear readiness value:
   - `ready-for-agent`: enough context exists for a developer or coding agent to implement it.
   - `needs-human-decision`: blocked by product, release, security, data, ownership, or operational ambiguity.
   - `blocked-by-task`: cannot start until another generated task is complete.
   - `manual-only`: requires credentials, access, deployment approval, production operation, or external-system action.
9. Assign each task to a capability area. Prefer product or domain capabilities such as `user-management`, `request-review`, `reporting`, or `notifications`. Use technical capability areas such as `infrastructure`, `deployment`, or `observability` only when the work does not naturally belong to one product capability or is shared across multiple capabilities.
10. Keep task files in one ordered sequence by default. Use the task index to provide grouped views by capability area, source slice or production workstream, type, and readiness.
11. Choose the task index structure based on expected growth, not only the current task count. If the source artefacts imply the task set may grow large, start with capability, source, type, and readiness groupings even when the initial task set is small.
12. Add capability sub-index files under `docs/tasks/capabilities/` when the main index becomes hard to scan or when the project already has clear capability areas. Capability sub-indexes are additive navigation aids; do not move or renumber existing task files to introduce them.
13. Ask the user before writing files when task granularity, release boundaries, missing decisions, tracker format, capability grouping, or remote issue publication materially changes the plan and the user has not asked to proceed with assumptions.
14. When running non-interactively or when the user asks to avoid follow-up questions, choose the smallest conservative task breakdown that fits the source artefacts and repository context, then record assumptions and unresolved decisions in the affected tasks.
15. Write or update task files under `docs/tasks/`, and keep the directory `README.md` current when files are added, moved, or deleted.

Do not create remote GitHub, Jira, Linear, or other tracker issues unless the user explicitly asks for remote issue creation.

## File Naming

Use zero-padded numeric prefixes and kebab-case titles:

```text
docs/tasks/0001-submit-first-request.md
docs/tasks/0002-add-request-status-review.md
```

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

## Task Sequence

| Task | Type | Readiness | Depends On |
| --- | --- | --- | --- |
| [Task title](0001-task-title.md) | product | ready-for-agent | None |

## By Capability Area

### Capability Name

- [Task title](0001-task-title.md)

## By Source

### Slice or Production Workstream

- [Task title](0001-task-title.md)

## By Type

### Product

- [Task title](0001-task-title.md)

### Production Readiness

### Validation

### Decision

### Manual Operation

## By Readiness

### Ready for Agent

- [Task title](0001-task-title.md)

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

| Task | Type | Readiness | Depends On |
| --- | --- | --- | --- |
| [Task title](../0001-task-title.md) | product | ready-for-agent | None |

## Exit Criteria

- List the observable criteria that prove this capability area has enough implementation coverage for the current release.

## Open Decisions

- List unresolved decisions that affect this capability area.
```

Capability files are navigation aids, not task containers. Do not move task files into capability folders.

## Task Template

Use this structure for each task file:

```markdown
# Task Title

## Source

Derived from:

- [slice title](../slices/0001-slice-title.md)
- [path to production](../production/path-to-production.md)

## Type

product | production-readiness | validation | decision | manual-operation

## Capability Area

Use kebab-case, for example `user-management`, `request-review`, `infrastructure`, or `observability`.

## Readiness

ready-for-agent | needs-human-decision | blocked-by-task | manual-only

## Outcome

Describe the observable product behaviour or release-readiness result in one or two sentences.

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

Omit `Notes` only when there is nothing useful to say.

Use `None` for dependencies when the task can start immediately.

## Quality Bar

A good implementation task:

- traces back to a vertical slice, path-to-production workstream, validation gate, or recorded decision
- has one clear outcome and a bounded scope
- is independently grabbable by one developer or coding agent
- preserves vertical slice intent instead of splitting work by technical layer
- records dependencies and readiness honestly
- includes observable, verifiable acceptance criteria and validation steps
- distinguishes product implementation from production-readiness, validation, decision, and manual-operation work

A good task index:

- preserves the full release sequence
- lets a reader find work by capability area, source slice, type, and readiness
- keeps task files in stable numeric order
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
