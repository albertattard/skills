Q: What task granularity should the first implementation task plan use?
A: Use small, independently grabbable tasks. A task may include UI, domain logic, persistence, tests, and documentation when those pieces are needed to deliver one observable outcome. Do not split tasks by technical layer unless the technical work is shared across multiple product capabilities or is required as its own production-readiness task.

Q: What capability areas should the tasks use?
A: Use these capability areas where they fit:

- `poc-lifecycle`: PoC creation, editing, state transitions, and lifecycle validation.
- `portfolio-triage`: manager portfolio views, blocked PoC visibility, stale PoC identification, and status review.
- `poc-context`: PoC detail pages, ownership/customer metadata, journal history, and contextual information.
- `journal`: journal entry creation, display, ordering, and audit trail behaviour.
- `container-delivery`: Maven build, container image build, image tagging, functional tests against the container, and GitHub Container Registry publishing.
- `operations`: health checks, structured error logging, configuration, persistence volume expectations, and rollback documentation.

Prefer product/domain capability areas over technical areas. Use `container-delivery` and `operations` only for work that is shared across product capabilities or comes directly from the path-to-production plan.

Q: Should production-readiness work become implementation tasks?
A: Yes. Include production-readiness tasks required for the first release, especially Maven test/build commands, container image build, functional tests against the built container, GitHub Actions publishing to GitHub Container Registry, persistent data directory configuration, health checks, structured error logging, and rollback documentation. Do not include production pull, deployment, or runtime rollout tasks because they are explicitly out of scope.

Q: What first release boundary should the task plan assume?
A: The first release should cover the manager triage workflow: managers can see current PoCs, identify blocked or stale work, and open the PoC context. Include PoC creation/editing, journal entries, and state transitions only where they are needed to keep the triage view accurate and verifiable.

Q: Should the task plan create capability sub-indexes from the start?
A: Yes. Create the main `docs/tasks/README.md` and capability sub-indexes under `docs/tasks/capabilities/` because the example should demonstrate the growth-friendly structure even if the initial task count is modest.

Q: What readiness values should the task plan prefer?
A: Mark tasks as `ready-for-agent` when the source artefacts and repository context provide enough information to implement them. Mark tasks as `needs-human-decision` when product, release, data, or operational details are still genuinely unresolved. Mark tasks as `manual-only` only for work that requires external access, credentials, or production operation. Use `blocked-by-task` when another generated task must land first.

Q: What validation expectations should tasks include?
A: Acceptance criteria must be observable and verifiable. Include automated test expectations when practical, including Maven tests and Playwright for Java functional tests against the running container. Use measurable thresholds only when they clarify behaviour or readiness; do not invent fake precision.

Q: Should remote tracker issues be created?
A: No. Write local Markdown task files under `docs/tasks/` only. Do not create GitHub, Jira, Linear, or other remote tracker issues.
