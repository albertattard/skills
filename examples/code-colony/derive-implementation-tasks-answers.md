Q: What task granularity should the first implementation task plan use?
A: Use small, independently grabbable tasks. A task may include UI, mission logic, content files, tests, and documentation when those pieces are needed to deliver one observable learner outcome.

Do not split tasks by technical layer unless the work is shared across multiple learner-visible capabilities or is required as release-readiness infrastructure.

Q: What capability areas should the tasks use?
A: Use these capability areas where they fit:

- `game-onboarding`: intro screen, start flow, player role, CORE explanation, and transition into Mission 01.
- `student-api`: learner-facing `Core` API, snippet wrapping, progressive disclosure from statements to methods/classes/packages, command availability, and beginner-readable API constraints.
- `learner-execution`: compilation, worker JVM execution, runtime failure handling, execution timeouts, result files, and feedback parsing.
- `mission-runtime`: mission maps, objective validation, status panels, simulation events, command semantics, and station-dependent actions.
- `mission-content`: content directory structure, Markdown briefings, command explanations, hints, explain copy, YAML mission manifest, map YAML, mission YAML, and content validation.
- `session-progression`: `gameSessionId` routing, in-memory mission state, carried successful code, completion state, and expired-session handling.
- `learner-feedback`: compile feedback, runtime feedback, mission-incomplete guidance, mission-success copy, and status panel notes.
- `delivery-validation`: Maven commands, Playwright for Java browser tests, Failsafe wiring, smoke checks, and local run documentation.

Prefer product/domain capability areas over technical areas. Use `delivery-validation` only for shared release-readiness work.

Q: Should production-readiness work become implementation tasks?
A: Yes, but keep it aligned to the local/trusted MVP.

Include tasks for:

- Maven Wrapper build and run commands
- `./mvnw test` and `./mvnw clean verify`
- Playwright for Java tests tagged `e2e`
- Maven Surefire excluding `e2e`
- Maven Failsafe running browser tests
- local run documentation
- readable logs and player-safe error feedback

Do not include cloud infrastructure, container publishing, CI/CD pipeline setup, public TLS/DNS, database provisioning, or production monitoring tasks for the MVP.

Q: What first release boundary should the task plan assume?
A: The first release should include:

- intro screen and start action
- Mission 01 connect flow
- Mission 02 charge flow
- Mission 03 repair flow
- in-memory game sessions
- carried successful code between missions where specified
- top-level content files, with YAML for mission manifest/map/behavior data and Markdown for learner-facing prose
- out-of-process learner Java execution
- automated unit, integration, and browser smoke coverage

Treat Mission 04 as a follow-up task only if the plan needs to prove that adding a mission with existing mechanics requires content/config files only.

The first release should keep the visible editor at the statement-snippet level. Tasks may prepare the architecture for later zoom-out stages, but should not implement method, class, or package editing until a later mission explicitly needs those concepts.

Q: Should the task plan create capability sub-indexes from the start?
A: Yes. Create the main `docs/tasks/README.md` and capability sub-indexes under `docs/tasks/capabilities/` because this example has multiple product, runtime, content, and validation capability areas.

Q: What readiness values should the task plan prefer?
A: Mark tasks as `ready-for-agent` when the source artefacts and repository context provide enough information to implement them.

Mark tasks as `needs-human-decision` for unresolved public hosting, stronger sandboxing, persistent progress, authentication, classroom rosters, analytics, or container/CI decisions.

Mark tasks as `manual-only` only for work that requires real external infrastructure, credentials, public network configuration, or classroom operations.

Use `blocked-by-task` when another generated task must land first.

Q: What validation expectations should tasks include?
A: Acceptance criteria must be observable and verifiable.

Include automated tests when practical:

- mission execution service tests for connect, charge, move, repair, incomplete states, and runtime failures
- YAML loader validation tests for mission manifest, maps, behavior, runtime, objectives, and validation copy
- Markdown content loading tests for learner-facing prose
- session progression tests
- controller tests for mission routes and expired sessions
- browser `e2e` smoke tests for the intro and playable mission flow
- Maven verification through `./mvnw clean verify`

Use measurable thresholds only when they reflect product behavior, such as battery reaching `5/5`, health reaching `5/5`, or CORE-01 reaching tile `B3`.

Q: Should remote tracker issues be created?
A: No. Write local Markdown task files under `docs/tasks/` only. Do not create GitHub, Jira, Linear, or other remote tracker issues.
