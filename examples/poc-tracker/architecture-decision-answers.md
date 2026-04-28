Q: Which architecture decisions should be recorded as ADRs for the first release?
A: Record ADRs for durable technical choices that materially constrain implementation tasks:

- Use a container image as the release artefact and publish it to GitHub Container Registry.
- Use GitHub Actions as the CI/CD pipeline for tests, container build, functional tests, and image publishing.
- Use Playwright for Java for functional tests against the running container.
- Persist the application database file on a runtime-mounted persistent volume under `/opt/application/data`.

Do not create ADRs for routine task sequencing, UI details, documentation index updates, or deferred production pull/deployment steps that are explicitly out of scope.

Q: What ADR status should unattended runs use?
A: Use `Accepted` when the decision is explicit in the path-to-production plan or source artefacts. Use `Proposed` only when the source artefacts identify a durable architecture decision but leave the actual choice unresolved.

Q: Which candidate decisions should remain open instead of becoming accepted ADRs?
A: Keep backup and restore handling for the persistent volume outside the accepted ADR set because it is explicitly out of scope for the MVP. If the model records it, it should be a proposed ADR or open question, not an accepted implementation constraint.

Q: How should ADRs relate to downstream implementation tasks?
A: Implementation tasks should reference only the ADRs that materially constrain them. Container delivery tasks should reference the container image and GitHub Actions ADRs. Functional testing tasks should reference the Playwright for Java ADR. Persistence and configuration tasks should reference the persistent volume ADR.

Q: Should the ADR step ask follow-up questions?
A: No. The runbook must run unattended. Use the source artefacts, repository context, and these answers. When a durable decision is unresolved, create a proposed ADR or leave the candidate in its source context and mention it in the final summary.
