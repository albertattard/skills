Q: What production target should the first release assume?
A: A small internal web deployment for managers inside the organisation. The path to production should stop at producing and publishing a deployable container image. Pulling the container and deploying it to production is explicitly out of scope.

Q: Who owns the first production release and ongoing operation?
A: The internal product or platform team owns release and operation. Managers are users of the application, not operators.

Q: What data posture should the first release use?
A: Treat PoC, customer, owner, and journal information as internal business data. The first release should avoid public access and avoid exporting or integrating with external systems unless already in scope. The MVP should not implement real authentication; managers identify themselves by selecting their name from a dropdown so ownership, journal entries, and state changes can be attributed while the first manager triage workflow is proven.

Q: What release strategy should the first version use?
A: Release the smallest manager triage workflow first: managers can see current PoCs, identify blocked or stale work, and open the PoC context. Defer richer workflow management, notifications, and integrations.

The build and delivery path should stay simple:

- Use Java 25 and Spring Boot for the application.
- Use Maven to build the project and its artefacts.
- Use GitHub Actions as the CI/CD pipeline.
- Build a runtime container based on `container-registry.oracle.com/java/jdk-no-fee-term:25.0.3`.
- Tag the container image with the short Git commit hash.
- Publish the container image to GitHub Container Registry as `ghcr.io/albertattard/poc-tracker:<short-git-commit-hash>`, or the equivalent GHCR image name if the repository name changes.
- Do not include production pull, deployment, or runtime rollout steps in the scope.

The application should persist its H2 database file on a persistent volume mounted into the container at runtime. The first release assumes one running application container, not multiple replicas.

Use `/opt/application/data` as the persistent volume mount path. The application should be deployed under `/opt/application`, and database files should live under the `data` directory so they persist container restarts.

Use `poc_tracker` or a similar name for the database file and related configuration.

Q: What validation should block production release?
A: Automated tests should cover the manager triage behaviour, stale PoC calculation, PoC creation/editing needed to keep the view accurate, journal entries, and state transitions.

The CI/CD pipeline should:

- run the Maven unit test suite, excluding tests tagged `e2e`
- build the application artefact with Maven
- build the container image
- run functional tests against the built container image during Maven integration tests
- publish the image to GitHub Container Registry only after the functional tests pass

Use Playwright for Java, not the Node.js Playwright package, for functional tests against the running containerised web application. Tag these tests with `@Tag("e2e")`, exclude the `e2e` tag from unit test runs, and include the `e2e` tag only during Maven integration tests.

The test and verification command should be exposed through Maven as `./mvnw verify`. The generated project should configure Maven so unit tests and integration tests run in the correct phases, with `e2e` tests executed only against the running container during integration testing.

Q: What observability and rollback expectations should the plan assume?
A: The first release should include basic application health checks and structured error logging. Rollback planning should be limited to retaining previous container images by tag. Pulling a previous image and deploying it to production is outside the scope of this path-to-production plan.

The persistent database file should live on a persistent volume. Backup and restore handling for the persistent volume is outside the scope of this MVP.

Q: What path-to-production details remain open?
A: The main path-to-production questions for the MVP are answered. The production plan should still record the required GitHub Actions publishing setup:

- Use the built-in `GITHUB_TOKEN` where possible.
- Grant the workflow `packages: write` permission to publish to GitHub Container Registry.
- Grant the workflow `contents: read` permission to check out the repository.
- Add repository secrets only if the project chooses not to use `GITHUB_TOKEN`; in that case, provide the username and a token with package write permissions.
