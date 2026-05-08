Q: Which architecture decisions should be recorded as ADRs for the first release?
A: Record ADRs for durable technical choices that materially constrain implementation tasks:

- Use Java 25 and Maven as the application and learner-code toolchain.
- Use Spring Boot with Thymeleaf, plus targeted HTMX where useful, for the browser game UI.
- Keep the first release local/trusted-environment only, with no public hosting decision.
- Execute learner-submitted Java in separate worker JVM processes rather than inside the web server JVM.
- Use a small student-facing `Core` API and hide engine/project structure from learners.
- Store game sessions in memory behind explicit `gameSessionId` routes for the MVP.
- Store runtime mission files in top-level `content/` outside compiled Java resources.
- Use YAML for structured mission manifest, map, runtime, objective, command, and validation data.
- Use Markdown only for learner-facing mission prose such as briefings, hints, and explanations.
- Use Playwright for Java with Maven Failsafe for browser-level `e2e` tests.

Do not create accepted ADRs for public deployment, containerization, cloud infrastructure, database persistence, authentication, teacher accounts, analytics, advanced sandboxing, multiplayer, or a separate JavaScript frontend framework. Those are out of scope or unresolved.

Q: What ADR status should unattended runs use?
A: Use `Accepted` when the decision is explicit in source artefacts or in the path-to-production answers. Use `Proposed` only when the source artefacts identify a durable decision but leave the actual choice unresolved.

Q: Which candidate decisions should remain open instead of becoming accepted ADRs?
A: Keep these as open questions or proposed decisions:

- public hosting model
- stronger sandboxing and resource isolation for untrusted learner code
- persistent learner progress
- database choice
- authentication and authorization
- teacher/facilitator dashboard
- analytics or telemetry
- container image and CI/CD pipeline
- content publishing workflow beyond repository files

Q: How should ADRs relate to downstream implementation tasks?
A: Application setup tasks should reference the Java 25/Maven and Spring Boot/Thymeleaf ADRs.

Learner execution tasks should reference the out-of-process execution ADR.

Student API and mission implementation tasks should reference the small `Core` API ADR.

Mission map, behavior, and authoring tasks should reference the runtime content, YAML mission configuration, and data-driven mission definition ADRs. Narrative and hint-writing tasks should reference the Markdown learner-prose decision only when they affect player-facing text.

Session progression tasks should reference the in-memory explicit session ADR.

Browser functional-test tasks should reference the Playwright for Java and Maven Failsafe ADR.

Release-readiness tasks should reference the local/trusted-environment ADR so they do not invent cloud, container, or public deployment work.

Q: Should the ADR step ask follow-up questions?
A: No. The runbook must run unattended. Use the source artefacts, repository context, and these answers. When a durable decision is unresolved, create a proposed ADR or leave the candidate in its source context and mention it in the final summary.
