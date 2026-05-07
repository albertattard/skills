Q: Which architecture decisions should be recorded as ADRs for the first release?
A: Record ADRs for durable technical choices that materially constrain implementation tasks:

- Use Java 25 with Maven as the application build, test, package, and run toolchain.
- Use Spring Boot with Thymeleaf for the local web application and server-rendered UI.
- Use Spring Data JPA with H2 in-memory database mode for session-only workshop data.
- Keep the application laptop-only with no container, CI/CD, infrastructure, or hosted production deployment for the MVP.
- Use Spring Boot Actuator for a simple local health endpoint.
- Use Playwright for Java for browser-level functional tests executed through the Maven Failsafe integration-test phase.

Do not create accepted ADRs for cloud deployment, containers, external databases, file persistence, PDF export, email/calendar integration, authentication, authorization, telemetry, or long-term workshop history because those are explicitly out of scope.

Q: What ADR status should unattended runs use?
A: Use `Accepted` when the decision is explicit in the path-to-production plan or source artefacts. Use `Proposed` only when the source artefacts identify a durable architecture decision but leave the actual choice unresolved.

Q: Which candidate decisions should remain open instead of becoming accepted ADRs?
A: Durable persistence, export format, authentication, multi-user access, sharing, workshop history, calendar integration, email invitations, and deployment beyond the trainer's laptop should remain future decisions or open questions. They should not become accepted ADRs for the MVP.

Q: How should ADRs relate to downstream implementation tasks?
A: Application setup tasks should reference the Java 25/Maven and Spring Boot/Thymeleaf ADRs. Domain and data-access tasks should reference the Spring Data JPA with H2 in-memory ADR when they need to explain repository structure and ephemeral data behaviour. Release-readiness and run-command tasks should reference the laptop-only ADR. Local operations tasks should reference the Spring Boot Actuator health endpoint ADR. Functional-test tasks should reference the Playwright for Java and Maven Failsafe ADR.

Q: Should the ADR step ask follow-up questions?
A: No. The runbook must run unattended. Use the source artefacts, repository context, and these answers. When a durable decision is unresolved, create a proposed ADR or leave the candidate in its source context and mention it in the final summary.
