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
