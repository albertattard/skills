# Pending

- Define how to measure success for each product or feature using measurable criteria.
- Verify the workflow an agent must follow when implementing a task. The agent should start with a clean worktree, with no pending or uncommitted changes, and all tests should pass where tests are present. The agent should start with a good workspace and finish with a good workspace, without leaving the workspace in a bad state or with failing tests.
- Review and define coding standards.
- Link DORA metrics into the success criteria and workflow guidance.
- Define how to capture sensible defaults so agents can apply them consistently.
- Rework `implement-task` so generic implementation guidance does not bake in Java, Spring Boot, server-rendered UI, Maven, or modular-modulith assumptions unless the skill is explicitly scoped to that stack.
- Revisit the `implement-task` clean-worktree preflight gate. It should inspect and protect existing work, but avoid blocking normal collaboration on unrelated tracked or untracked changes.
- Add explicit path-to-production release profiles, such as local-only, internal demo, internal production, and public production, so missing deployment, data, security, exposure, and ownership decisions do not become unsafe implicit defaults.
- Add a non-interactive fallback to `create-scope`, such as batching the highest-impact questions or proceeding with clearly labelled conservative assumptions when unattended runs cannot ask follow-up questions.
- Define workflow skip or merge criteria so small applications do not have to produce scope, PRD, slices, production plan, ADRs, task indexes, capability indexes, and task files before useful code can start.
- Strengthen ADR guidance so durable decisions explicitly name considered and rejected alternatives instead of only justifying the selected option.

## `examples/sw-runbook.yaml` Walkthrough Improvements

- Add an opening orientation that explains what the reader will build and learn: starting from a product idea, turning ambiguity into reviewable artefacts, and using agentic coding as a controlled workflow rather than as unconstrained code generation.
- Add a workflow map near the top of the runbook: product description -> MVP scope -> PRD -> vertical slices -> path to production -> ADRs -> implementation tasks -> implemented task.
- Explain unattended versus interactive mode once near the beginning. Clarify that fixture answer files make the demo deterministic, while real interactive use should let the agent ask product, platform, and architecture follow-up questions.
- Strengthen the product-description section by explaining that the initial description is intentionally incomplete and should be mined for goals, users, constraints, unknowns, and domain vocabulary before scope is created.
- Add a `DisplayFile` entry for `docs/product/description.md` so the rendered walkthrough shows the input that drives the workflow.
- Explain once why the runbook commits after each phase: commits create review checkpoints, rollback points, and coherent boundaries between planning, task derivation, and implementation.
- Add a short explanation before creating `AGENTS.md` that repository instructions are operational context for future agent runs, not only human-facing project documentation.
- Add a "what good looks like" review checklist after each major generated artefact before committing it: scope, PRD, vertical slices, path to production, ADRs, and implementation tasks.
- Expand the vertical-slice section with a contrast between a user-visible end-to-end slice and horizontal technical tasks such as database, API, and UI-only work.
- Add `DisplayFile` previews for the most important generated artefacts, such as `docs/scopes/mvp-scope.md`, `docs/requirements/product-requirements-document.md`, `docs/slices/README.md`, `docs/production/path-to-production.md`, and `docs/tasks/README.md`.
- Treat the repeated implementation loop as an advanced batch mode. Make the first implemented task the main teaching path, then explain that looping over remaining tasks should happen only after task quality and validation gates are trusted.
- Add a closing section that explains how engineers can transfer the pattern to their own project: start with a product description, add repository instructions, introduce skills for repeated work, review and commit at each planning boundary, and implement one ready task at a time.
