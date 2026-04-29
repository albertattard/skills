Q: What task granularity should the first implementation task plan use?
A: Use small, independently grabbable tasks. A task may include UI, domain logic, Spring Data JPA repositories backed by H2 in-memory storage, validation, tests, and documentation when those pieces are needed to deliver one observable trainer outcome. Do not split tasks by technical layer unless the technical work is shared across multiple product capabilities or is required as its own local release-readiness task.

Q: What capability areas should the tasks use?
A: Use these capability areas where they fit:

- `workshop-context`: workshop title, customer name, date, duration, audience, goals, and validation.
- `agenda-planning`: agenda block creation, editing, deletion, ordering, duration totals, and duration mismatch visibility.
- `preparation-tracking`: preparation item creation, pending/done status, and visibility of remaining preparation work.
- `facilitator-view`: read-only run-of-show view with workshop context, ordered agenda, timing, notes, exercise/material references, and preparation status.
- `application-platform`: Java 25, Spring Boot, Thymeleaf, Maven wrapper, Spring Data JPA, H2 in-memory database configuration, Spring Boot Actuator, and local run commands.
- `verification`: Maven verification, unit tests, Maven Failsafe integration-test configuration, Playwright for Java `e2e` tests against the locally running application, and test documentation.
- `local-operations`: Spring Boot Actuator health/startup checks, local error logging, and documentation of ephemeral data and laptop-only usage.

Prefer product/domain capability areas over technical areas. Use `application-platform`, `verification`, and `local-operations` only for work that is shared across product capabilities or comes directly from the path-to-production plan.

Q: Should release-readiness work become implementation tasks?
A: Yes. Include local release-readiness tasks required for the first release, especially Java 25 and Spring Boot project setup, Thymeleaf templates, Spring Data JPA repositories, H2 in-memory configuration, Spring Boot Actuator health, Maven wrapper and `./mvnw verify`, Maven Surefire and Failsafe separation, Playwright for Java tests tagged `e2e`, local run instructions, local health/startup checks, error logging, and documentation that data is lost when the application stops.

Do not include container build, image publishing, CI/CD, cloud infrastructure, deployment, external database provisioning, backup/restore, or production rollout tasks.

Q: What first release boundary should the task plan assume?
A: The first release should cover one local workshop plan: the trainer creates workshop context, adds/edits/deletes/reorders agenda blocks, sees planned duration status, tracks preparation items, marks preparation items done, and opens a facilitator view. Exclude durable persistence, authentication, multiple users, workshop history, PDF export, calendar integration, email invitations, attendee management, resource booking, containers, CI/CD, and infrastructure.

Q: Should the task plan create capability sub-indexes from the start?
A: Yes. Create the main `docs/tasks/README.md` and capability sub-indexes under `docs/tasks/capabilities/` because the example should demonstrate the growth-friendly structure while keeping infrastructure work intentionally small.

Q: What readiness values should the task plan prefer?
A: Mark tasks as `ready-for-agent` when the source artefacts and repository context provide enough information to implement them. Mark tasks as `needs-human-decision` only when product behaviour is genuinely unresolved, such as future export format, durable persistence, sharing, or integration choices. Mark tasks as `manual-only` only for work that requires a human to run or inspect the local application outside automated tests. Use `blocked-by-task` when another generated task must land first.

Q: What validation expectations should tasks include?
A: Acceptance criteria must be observable and verifiable. Include automated test expectations when practical, including Spring MVC/domain tests for validation and ordering rules, Maven `./mvnw verify`, unit tests that exclude `e2e` tests, and Playwright for Java functional tests tagged with `@Tag("e2e")` against the locally running Spring Boot application during the Maven Failsafe integration-test phase. Use measurable thresholds only when they clarify behaviour, such as matching total agenda minutes to workshop duration.

Q: Should remote tracker issues be created?
A: No. Write local Markdown task files under `docs/tasks/` only. Do not create GitHub, Jira, Linear, or other remote tracker issues.
