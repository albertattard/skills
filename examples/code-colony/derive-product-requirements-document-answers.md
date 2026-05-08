Q: Who is the first real user for the MVP?
A: A beginner learner, especially a kid or early teen, who wants to learn introductory Java through short game missions in the browser.

Q: What first-version behaviour proves the product is useful?
A: The learner can use Java code in the browser to control a CORE unit and see immediate, understandable mission feedback.

The minimum proof is that `Core.connect();` compiles and runs as real Java, causes CORE-01 to come online, updates the mission status panel, and produces mission feedback that explains what happened.

Q: What mission set should the PRD treat as the first release boundary?
A: The first release should cover the intro plus three missions:

- Mission 01, `Wake The CORE`: call `Core.connect();`
- Mission 02, `Charge The CORE`: assign the returned CORE reference and call `core.charge();` repeatedly
- Mission 03, `Repair The CORE`: sequence `core.move();` and `core.repair();` after connecting

Mission 04 and later missions should be treated as follow-up expansion unless needed to prove no-code mission addition. The PRD may mention the future direction, but acceptance criteria for the MVP should stop at Mission 03.

Q: How should learner code execution be represented in requirements?
A: Requirements should say that learner code is real Java compiled and executed by the application, not string-matched text. The learner edits a small code snippet in a browser surface, and the system wraps it in a controlled execution context.

The PRD should require compile errors, runtime failures, and mission-incomplete states to be shown in beginner-readable language.

Q: How should the learner code editing surface evolve over time?
A: Use progressive disclosure. The first missions should expose only editable statements inside a hidden method body so the learner can focus on cause and effect without seeing package declarations, imports, class declarations, or method signatures.

Later missions should intentionally zoom out:

- first edit statements
- then edit and create methods
- then edit a full class
- eventually understand package-level organization

The PRD should treat this as a product and learning principle. Do not expose the full Java project model in the MVP just because the runtime can support it. Reveal each larger code structure only when a mission has a clear educational reason to introduce it.

Q: What should the learner-facing API include for the MVP?
A: Keep the student API small:

- `Core.connect()` for establishing control
- a returned `Core` reference for later actions
- `core.charge()`
- `core.move()`
- `core.repair()`

Do not expose engine internals, package declarations, imports, class declarations, advanced object design, collections, threading, file access, or unrestricted Java APIs as learner-facing concepts in the MVP.

Q: How should mission content be managed?
A: The PRD should require mission configuration and player-facing mission content to be authored outside Java code.

Use the right file format for the kind of content:

- `content/missions/missions.yaml` defines mission order, route slugs, and enabled missions.
- `content/missions/<mission-id>/map.yaml` defines structured map data, including grid size, tile legend, base grid, stations, spawns, coordinates, battery, and health.
- `content/missions/<mission-id>/mission.yaml` defines structured behavior, including allowed commands, runtime command gating, objective kind, execution settings, initial status templates, validation messages, and completion rules.
- `content/missions/<mission-id>/content.md` stores learner-facing prose such as briefing text, hints, command explanations, initial-run copy, and explain-dialog text.

Do not use Markdown as the source of truth for structured mission rules or map state. Markdown is appropriate for prose, but YAML should own data that needs schema validation and predictable loader behavior.

For missions that reuse supported mechanics, a learner or content author should be able to change mission data by editing files under top-level `content/` without recompiling Java.

Q: How should learner progress and session state work?
A: Use explicit browser session routes backed by server-side in-memory session state.

When a learner starts the game, the server creates a `gameSessionId`. Mission navigation and run requests should include that session id. Mission state should track current code, successful code, and completion state for each mission. Account login, long-term saves, classroom rosters, and persistent progress are out of scope.
