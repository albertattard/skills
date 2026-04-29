Q: What production target should the first release assume?
A: A local laptop-only application run by the trainer during workshop preparation and facilitation. The path to production should not describe server deployment, cloud infrastructure, container delivery, CI/CD, external hosting, or multi-user operation.

The release target is a runnable Spring Boot application that can be started locally from the repository using Maven.

Q: Who owns the first release and ongoing operation?
A: The trainer owns running and operating the application locally. There is no separate platform, operations, support, or release team for the MVP.

Q: What data posture should the first release use?
A: Workshop plans are local working data. The MVP uses Spring Data JPA with an H2 in-memory database and intentionally does not provide durable persistence. Data is expected to disappear when the application process stops.

The first release should avoid collecting sensitive customer information beyond the minimal workshop context needed for preparation. It should not implement accounts, authentication, authorization, sharing, telemetry, external integrations, backups, or exports.

Q: What release strategy should the first version use?
A: Release the smallest local workflow first: a trainer creates one workshop plan, adds and reorders agenda blocks, tracks preparation items, and uses the facilitator view.

The build and run path should stay simple:

- Use Java 25 for the application runtime.
- Use Spring Boot and Thymeleaf for the web application.
- Use Maven to build, test, package, and run the project.
- Use Spring Data JPA with H2 in-memory database mode for local session data.
- Use Playwright for Java for functional browser tests.
- Use Maven Failsafe for browser-level integration tests.
- Use Spring Boot Actuator for a simple local health endpoint.
- Expose local run and verification commands through Maven.
- Do not build or publish a container image.
- Do not create a CI/CD pipeline.
- Do not provision infrastructure.

Q: What validation should block the local release?
A: Automated tests should cover the main trainer workflow: creating the workshop context, adding agenda blocks, reordering agenda blocks, seeing total duration mismatch or status, adding preparation items, marking preparation items done, and opening the facilitator view.

Use Maven as the verification entry point. The project should expose `./mvnw verify` for automated validation. Playwright for Java functional tests should run against the locally started Spring Boot application through the Maven Failsafe integration-test phase. Tag browser tests with `@Tag("e2e")`, exclude them from unit-test-only runs, and include them only in the integration-test phase.

Q: What observability and rollback expectations should the plan assume?
A: Keep operations local and minimal. Include a Spring Boot Actuator health endpoint for local startup checks. Include useful local error logging for failed requests and validation problems.

Rollback means returning to the previous Git commit or previous local build. There are no published artefacts, deployed environments, persistent data migrations, or production rollback steps in scope.

Q: What path-to-production details remain open?
A: The main local release direction is answered: Java 25, Spring Boot, Thymeleaf, Maven, Spring Data JPA with H2 in-memory database, Playwright for Java through Maven Failsafe, Spring Boot Actuator health, laptop-only execution, no containers, no CI/CD, no infrastructure, and no durable persistence.

The production plan should still record these constraints clearly so downstream tasks do not add unnecessary production work:

- Data is intentionally ephemeral and disappears when the application stops.
- The first release is not suitable for shared customer data, multi-user usage, or long-term workshop records.
- Any future durable persistence, export, deployment, authentication, or sharing feature would require a new product and architecture decision.
