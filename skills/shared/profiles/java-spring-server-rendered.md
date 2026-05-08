# Java Spring Server-Rendered Defaults

Profile id: `java-spring-server-rendered`

Use this profile only for Java/Spring Boot applications with server-rendered UI.

Do not apply this profile to generic Java libraries, command-line tools, HTTP APIs without server-rendered pages, or applications whose existing conventions point to another stack.

## Build And Validation

- Prefer Maven only when no existing build tool conflicts and the profile is explicitly selected or already reflected by the repository.
- Use `./mvnw verify` as the main validation command when the Maven wrapper exists.
- Keep unit tests and browser-level or integration tests separated when the repository already supports that split.

## Application Structure

- Preserve the existing package layout when one exists.
- For a new small Spring Boot application with no existing convention, group code by product capability instead of technical layer.
- Keep controllers, request or form objects, application services, repositories, entities, and domain command or value objects close to the capability they serve until the module grows enough to justify subpackages.
- Do not pass web or form types into domain entities. Map them to domain commands or values first.

## Server-Rendered Web

- Prefer semantic HTTP method mappings for resource operations: `GET` for reads, `POST` for creation or commands, `PUT` or `PATCH` for updates when appropriate, and `DELETE` for deletes.
- When plain HTML forms cannot submit non-`GET` or non-`POST` verbs directly, prefer the framework's standard method override support over action-suffixed `POST` routes such as `/delete`, unless the repository already uses command-style `POST` endpoints.
- Prefer shared templates, fragments, styles, and form conventions when more than one screen uses the same application shell.

## Configuration

- Preserve the repository's existing configuration format.
- For a new Spring Boot application with no existing convention, prefer `application.yml` over `application.properties` when hierarchical configuration is needed.

## Browser Tests

- Use the repository's existing browser-test convention when one exists.
- If the selected stack and repository use Java-only validation, prefer Java-compatible browser tests over adding a separate JavaScript test runtime only for browser coverage.
