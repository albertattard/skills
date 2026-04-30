# Java Spring API Defaults

Profile id: `java-spring-api`

Use this profile only for Java/Spring Boot applications that expose an HTTP API without server-rendered UI as the primary user interface.

Do not apply this profile to server-rendered web applications, generic Java libraries, command-line tools, or applications whose existing conventions point to another stack.

## Build And Validation

- Prefer Maven only when no existing build tool conflicts and the profile is explicitly selected or already reflected by the repository.
- Use `./mvnw verify` as the main validation command when the Maven wrapper exists.
- Keep fast unit tests separate from slower integration or contract tests when the repository already supports that split.

## Application Structure

- Preserve the existing package layout when one exists.
- For a new small Spring Boot API with no existing convention, group code by product capability instead of technical layer.
- Keep controllers, request objects, application services, repositories, entities, and domain command or value objects close to the capability they serve until the module grows enough to justify subpackages.
- Do not pass transport request types into domain entities. Map them to domain commands or values first.

## HTTP API

- Prefer semantic HTTP methods for resource operations: `GET` for reads, `POST` for creation or commands, `PUT` or `PATCH` for updates, and `DELETE` for deletes.
- Keep request and response contracts explicit and stable.
- Validate incoming requests at the boundary and return clear, user-meaningful error responses.
- Add API-level tests for request handling, validation failures, persistence effects, and authorization or access boundaries when those concerns are in scope.

## Configuration

- Preserve the repository's existing configuration format.
- For a new Spring Boot application with no existing convention, prefer `application.yml` over `application.properties` when hierarchical configuration is needed.
