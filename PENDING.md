# Pending

## Skill Behaviour

1. Define a consistent success-measure model for product and feature artefacts.
   PRDs currently include `Success Measures`, but the skills do not yet require
   measurable criteria with a consistent shape or trace them through scope, PRD,
   slices, tasks, and validation.
2. Review and define coding standards for generated implementation work. Current
   skills include testing, design, and UI guidance, but there is no explicit
   coding standard covering naming, formatting, module layout, error handling,
   logging, configuration, security conventions, or language-specific style
   boundaries.
3. Link DORA metrics into success criteria and workflow guidance where they are
   useful. Define when deployment frequency, lead time for changes, change
   failure rate, and restore time should influence production planning, task
   validation, and release-readiness checks.
4. Add AI-assisted development ROI guidance based on DORA's ROI framing. Capture
   baseline metrics, tuition cost, reclaimed engineering capacity, DORA delivery
   metrics, quality and rework signals, and validation evidence so agentic
   workflows can be evaluated as business outcomes rather than only
   code-generation speed.
5. Add an AI-assisted development measurement plan template. The template should
   cover baseline period, adoption window, expected early productivity dip or
   tuition cost, human review effort, failed or corrected agent runs, validation
   evidence, quality outcomes, and how reclaimed engineering capacity will be
   reinvested.
6. Define where AI ROI evidence belongs in the workflow. Decide whether to
   create a dedicated skill, extend `derive-path-to-production`, extend
   `derive-implementation-tasks`, or add lightweight sections to generated
   artefacts without turning every small project into a metrics programme.
7. Define how to capture sensible defaults so agents can apply them
   consistently. Shared profiles cover stack-specific guidance after a profile
   is selected, but there is no general mechanism for recording project defaults
   such as release target, validation commands, documentation conventions, test
   strategy, or UI baseline expectations.
8. Revisit the `implement-task` clean-worktree preflight gate. It should inspect
   and protect existing work, but avoid blocking normal collaboration on
   unrelated tracked or untracked changes.
9. Add explicit path-to-production release profiles, such as local-only,
    internal demo, internal production, and public production, so missing
    deployment, data, security, exposure, and ownership decisions do not become
    unsafe implicit defaults.
10. Add a non-interactive fallback to `create-scope`, such as batching the
    highest-impact questions or proceeding with clearly labelled conservative
    assumptions when unattended runs cannot ask follow-up questions.
11. Define workflow skip or merge criteria so small applications do not have to
    produce scope, PRD, slices, production plan, ADRs, task indexes, capability
    indexes, and task files before useful code can start.
12. Strengthen ADR guidance so durable decisions explicitly name considered and
    rejected alternatives instead of only justifying the selected option.

## `examples/sw-runbook.yaml` Walkthrough Improvements

1. Explain unattended versus interactive mode once near the beginning. The
   runbook currently explains this near each skill invocation, but it should
   introduce the distinction once up front so fixture answer files are clearly
   framed as deterministic demo inputs rather than normal interactive behaviour.
2. Add a `DisplayFile` entry for `docs/product/description.md` so the rendered
   walkthrough shows the input that drives the workflow.
3. Explain once why the runbook commits after each phase: commits create review
   checkpoints, rollback points, and coherent boundaries between planning, task
   derivation, and implementation.
4. Add a "what good looks like" review checklist after each major generated
   artefact before committing it: scope, PRD, vertical slices, path to
   production, ADRs, and implementation tasks.
5. Add `DisplayFile` previews for the most important generated artefacts, such
   as `docs/scopes/mvp-scope.md`,
   `docs/requirements/product-requirements-document.md`,
   `docs/slices/README.md`, `docs/production/path-to-production.md`, and
   `docs/tasks/README.md`.
6. Add a closing section that explains how engineers can transfer the pattern to
   their own project: start with a product description, add repository
   instructions, introduce skills for repeated work, review and commit at each
   planning boundary, and implement one ready task at a time.
