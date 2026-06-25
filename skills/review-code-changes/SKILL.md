---
name: review-code-changes
description: Use when Codex needs to review current Git changes, commit ranges, patches, or branch diffs as a Staff Software Engineer. The skill inspects diffs, tests, and relevant surrounding code; challenges design assumptions; focuses on high-impact production risks; and reports findings in a severity-ordered, staged format.
---

# Review Code Changes

## Overview

Review the current code changes as a Staff Software Engineer.

Inspect the changed code, tests, and relevant surrounding code. Focus on correctness, architecture, security, performance, maintainability, test coverage, and production readiness. Ignore minor style or formatting concerns unless they hide a real defect.

## Inputs

Prefer the most explicit review target available:

1. A user-provided PR, commit range, pair of SHAs, patch file, or diff.
2. The current branch compared with a user-provided or inferred base branch.
3. Staged, unstaged, and untracked worktree changes when no branch comparison exists.

When inferring a base branch, prefer the current branch's upstream, then likely repository bases such as `origin/main`, `main`, `origin/master`, or `master`. If the review target is still ambiguous, ask for the base, range, or patch instead of inventing one.

## Workflow

1. Identify the review target and any dirty worktree state.
2. Inspect the changed file list and summary diff before reading individual files.
3. Read the full diff for changed production code, tests, configuration, migrations, scripts, and behaviour-affecting documentation.
4. Read surrounding code when needed to verify contracts, call sites, data flow, authorization, transactions, error handling, concurrency, or lifecycle assumptions.
5. Inspect tests that changed or should have changed. Check whether they would fail for the issue being reviewed.
6. Run lightweight validation only when it materially improves review confidence and is safe in the repository.
7. Prefer fewer, higher-confidence findings over speculative concerns.

For large diffs, review by risk area rather than file order. Start with externally reachable behaviour, data writes, security boundaries, migrations, and shared abstractions.

## Finding Standards

Report a finding only when it is actionable and tied to a concrete risk.

Each finding should include:

- severity: `Blocking`, `High`, `Medium`, or `Low`
- file and line reference when available
- what can go wrong
- why the current code permits it
- a recommended course of action
- the missing or weak test signal, when relevant

Do not report:

- style-only preferences
- hypothetical rewrites without a concrete failure mode
- broad architecture opinions that are not connected to this change
- missing tests for behaviour that cannot reasonably be tested locally

## Output

If you find one or more issues:

1. Start with a short severity-ordered summary only.
2. Then expand only the first issue with file and line references, why it matters, and a recommended course of action.
3. Stop after the first expanded issue and wait for the user to ask for the next issue.

Use this shape:

```markdown
Findings summary:

1. [Blocking] Short issue title - file:line
2. [High] Short issue title - file:line

Expanded finding:

[Blocking] Short issue title

`path/to/file.ext:123`

What goes wrong:
...

Why it matters:
...

Recommended action:
...
```

If there are no blocking findings, say so clearly and note residual risks or useful follow-up tests.

If the review cannot be completed, state the blocker and the smallest input or repository state needed to continue.
