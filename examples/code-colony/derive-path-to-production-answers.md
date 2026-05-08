Q: What production target should the first release assume?
A: A local or trusted classroom/workshop deployment operated by the project maintainer or facilitator. Learners access the app through a browser, but the MVP should not assume public internet hosting.

This is an important boundary. The project executes learner-submitted Java code out of process, but that is not enough to claim the system is safe for untrusted public traffic. Public hosting, multi-tenant sandboxing, abuse controls, rate limits, account security, and infrastructure isolation are future architecture decisions.

Q: Who owns the first release and ongoing operation?
A: The project maintainer or workshop facilitator owns the first release and operation. There is no separate platform, security, support, or operations team for the MVP.

Q: What data posture should the first release use?
A: Minimize data.

The MVP should use anonymous session state only:

- no accounts
- no learner profiles
- no classroom roster
- no long-term progress storage
- no database
- no telemetry requirement
- no storage of learner-submitted code beyond the active server-side session

Runtime content lives in the repository under top-level `content/`. Game sessions may be stored in memory and may expire after inactivity.

Q: What release strategy should the first version use?
A: Release the smallest trusted-environment browser prototype:

- Java 25 application
- Spring Boot backend
- Thymeleaf server-rendered UI with targeted HTMX interactions where useful
- Maven Wrapper for build, test, package, and local run commands
- real Java compilation and execution of learner snippets in separate worker JVM processes
- beginner-readable compile, runtime, and mission validation feedback
- top-level `content/` directory with YAML for mission structure/behavior and Markdown for learner-facing prose
- explicit `gameSessionId` routes for mission progression
- no database
- no container image requirement
- no cloud deployment
- no CI/CD pipeline requirement
- no public hosting

The repository should expose:

- `./mvnw test` for fast unit and integration feedback
- `./mvnw clean verify` for full verification including browser-level `e2e` coverage
- `./mvnw spring-boot:run` for local operation

Q: What validation should block release?
A: Automated validation should block release when core learner flows fail.

Tests should cover:

- intro start flow creates a game session and opens Mission 01
- Mission 01 succeeds after `Core.connect();`
- Mission 02 requires a CORE reference and reaches full battery after repeated `core.charge();`
- Mission 03 requires movement to the repair station and repeated `core.repair();`
- mission state carries successful code forward where specified
- compile errors are parsed into readable feedback
- runtime failures do not crash the web server
- mission manifest, maps, and behavior YAML fail fast with clear diagnostics
- disabled or missing mission content is handled predictably
- browser smoke coverage exercises the playable mission flow

Use Playwright for Java for browser-level functional tests. Tag browser tests with `@Tag("e2e")`, exclude them from normal unit-test runs, and run them during Maven Failsafe verification.

Q: What observability and rollback expectations should the plan assume?
A: Keep operations local and simple.

The application should log compile and execution failures clearly enough for the facilitator to diagnose broken missions or environment issues. Player-facing feedback should remain beginner-readable and not expose internal stack traces.

Rollback means returning to a previous Git commit or previous local build. There are no published artifacts, production databases, migrations, cloud resources, or deployment rollback steps in scope for the MVP.

Q: What path-to-production details remain open?
A: The main first-release path is answered: local/trusted browser prototype, Java 25, Spring Boot, Thymeleaf, HTMX where useful, Maven, out-of-process Java execution, in-memory sessions, YAML-backed mission configuration under top-level `content/`, Markdown-backed learner prose, Playwright for Java, and no database or public deployment.

Record these future decisions as open rather than silently assuming them:

- stronger sandboxing for learner-submitted Java
- public hosting or classroom network deployment model
- persistent learner progress
- teacher dashboards or rosters
- authentication and authorization
- telemetry and analytics
- packaged content publishing workflow
- containerization and CI/CD
