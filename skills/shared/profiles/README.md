# Shared Profiles

Shared profiles provide stack-specific implementation guidance for skills that need concrete conventions after the project stack is known.

Profiles are not global defaults. They must not override user instructions, repository conventions, accepted architecture decisions, or task-specific constraints.

## Selection Rules

Use a profile only when one of these is true:

- The user explicitly names the profile.
- `AGENTS.md` names the profile.
- An accepted ADR selects the stack covered by the profile.
- The selected task front matter names the profile.
- Existing repository files clearly match the profile.

If no profile is selected, stay stack-neutral.

If more than one profile matches, ask the user or stop with a `needs-human-decision` task instead of guessing.

If a profile conflicts with existing repository conventions, follow the repository conventions and report the conflict.

Load at most one profile for a task. Do not load every profile just because this directory exists.

## Profile Selection Locations

Prefer profile selection in this order:

1. Current user instruction.
2. Repository instructions in `AGENTS.md`.
3. Accepted ADRs under `docs/adrs/`.
4. Selected task front matter, using `default_profile`.
5. Strongly matching repository files.

Example task front matter:

```yaml
default_profile: java-spring-server-rendered
```

Example `AGENTS.md` section:

```markdown
## Default Skill Profile

Use `java-spring-server-rendered` when a new application stack is not otherwise specified.
```

## Available Profiles

| Profile | File | Use When |
| --- | --- | --- |
| `java-spring-server-rendered` | [java-spring-server-rendered.md](java-spring-server-rendered.md) | Java/Spring Boot application with a server-rendered UI. |
| `java-spring-api` | [java-spring-api.md](java-spring-api.md) | Java/Spring Boot HTTP API without a server-rendered UI. |
