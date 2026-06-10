---
name: create-java-web-functional-test-harness
description: Use when Codex needs to create an opinionated Java Maven functional-test project for a web application, using JUnit 5, Playwright, Java 25, a disposable Docker container application harness, a browser harness, and small domain-specific fluent page objects derived from existing manual or automated functional behaviour.
---

# Create Java Web Functional Test Harness

## Overview

Create a separate Maven functional-test project for a web application.

The harness should characterize important user-visible behaviour through a real browser against an application running in a Docker container. It should be small enough to understand, but structured enough that later tests read like product workflows instead of low-level browser automation.

Use any provided functional-test fixture as a reference for structure and tone, not as a source of product-specific names. The Spring Boot fixture discussed by the user is one example of the intended style:

- a standalone `functional-tests` Maven project
- Java 25 for compiling and running tests
- JUnit Jupiter test classes
- Playwright for browser automation
- a `PlaywrightBrowserHarness`-style browser wrapper
- an `<Application>ApplicationHarness`-style Docker wrapper
- domain-specific page objects or workflow drivers with fluent assertions
- test methods that describe user workflows, not selectors

Do not install this skill or modify local Codex skill registries. This skill is for creating project files in the target repository.

## Hard Rules

- Put functional tests in a separate Maven project named `functional-tests` unless the user explicitly requests another path.
- Do not place functional tests inside the application build unless the repository already has a stronger convention and the user confirms using it.
- Use Java 25 as the functional-test runtime by default:
  - set `<java.version>25</java.version>`
  - set `<maven.compiler.release>${java.version}</maven.compiler.release>`
- Use JUnit Jupiter and Playwright as test dependencies.
- Expect Docker to run the application under test. Prefer a disposable test-owned container rather than requiring a manually started container.
- Keep the application harness simple:
  - start one container
  - bind the application port to `127.0.0.1`
  - wait for readiness
  - forward logs
  - stop the container during cleanup
- Do not introduce Testcontainers unless the user explicitly asks or the repository already standardizes on it.
- Do not require Spring Boot test dependencies in the functional-test project.
- Do not share application test classes or production internals with the functional-test project.
- Derive workflows, routes, fields, credentials, expected data, and assertions from repository evidence or provided functional tests. Do not invent product behaviour.
- Keep raw Playwright `Page`, `Locator`, selectors, waits, and parsing details out of multi-step test methods. Put them behind page objects, workflow objects, or small helpers.
- Validate the harness with Maven when practical.

## Inputs

Inspect the target web application before writing files.

Useful evidence includes:

- existing manual test instructions, screenshots, or runbooks
- existing browser tests, smoke tests, fixtures, or characterization tests
- application routes, controllers, templates, static assets, and forms
- seed data, migrations, fixtures, default users, and documented credentials
- Dockerfiles, compose files, image names, exposed ports, and runtime configuration
- build files, wrapper scripts, Java versions, and module layout
- health endpoints or simple pages that can prove readiness

If the user provides a functional-test fixture directory, treat it as reference material. Reuse its structure and style where appropriate, but generalize names, package paths, readiness checks, credentials, and page objects to the target application.

## Challenge Ambiguity

Challenge the request before writing files when a missing decision would make the generated harness misleading or brittle.

Ask the user when any of these cannot be determined from evidence:

- which module or repository is the web application under test
- how to build the Docker image
- the Docker image name to run
- the container port exposed by the application
- a readiness endpoint or stable readiness signal
- the main user workflow to characterize
- required credentials or seed data for an authenticated workflow

If only a minor value is unknown, choose the smallest configurable default and make it explicit in code and the final summary. For example, use `application.container.image` as a system property rather than hard-coding a guessed image name.

Push back on requests to create exhaustive browser coverage before the product workflows are understood. The first harness should prove the test infrastructure and one or two critical workflows; later tests can expand coverage.

## Project Layout

Create this layout by default:

```text
functional-tests/
  pom.xml
  src/test/java/<base-package>/functional/
    <Application>FunctionalTest.java
    browser/
      BrowserConsumer.java
      BrowserHarness.java
      PlaywrightBrowserHarness.java
    support/
      <Application>ApplicationHarness.java
    <domain-or-application>/
      <Application>.java
      <PageOrWorkflow>.java
      ...
```

Choose `<base-package>` from the application package when clear. If the application package is not clear, use a neutral package based on the group id, such as `com.example.functional`, and report the assumption.

Name the domain package after the application or primary capability, not after a technical tool. Examples:

- `account`
- `admin`
- `dashboard`
- `requests`
- `records`

## Maven Project

Use this Maven shape unless repository evidence requires a newer patch version:

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <java.version>25</java.version>
    <maven.compiler.release>${java.version}</maven.compiler.release>
    <junit-jupiter.version>5.10.5</junit-jupiter.version>
    <playwright.version>1.59.0</playwright.version>
    <maven-compiler-plugin.version>3.11.0</maven-compiler-plugin.version>
    <maven-surefire-plugin.version>3.2.5</maven-surefire-plugin.version>
    <exec-maven-plugin.version>3.1.1</exec-maven-plugin.version>
</properties>
```

Dependencies:

- `com.microsoft.playwright:playwright`
- `org.junit.jupiter:junit-jupiter-api`
- `org.junit.jupiter:junit-jupiter-engine`

Plugins:

- `maven-compiler-plugin`
- `maven-surefire-plugin` with `<useModulePath>false</useModulePath>`
- `exec-maven-plugin`

Do not make the functional-test project a child module unless the user requests Maven reactor integration. A separate project keeps migration characterization tests independent from application build failures.

## Browser Harness

Create a small browser harness that owns Playwright lifecycle.

Required behaviour:

- construct Playwright once for the harness
- launch Chromium headless by default
- support an optional browser channel from:
  - `playwright.browser.channel` system property
  - `PLAYWRIGHT_BROWSER_CHANNEL` environment variable
- create a new page for each browser session
- expose a domain-specific root object to tests
- close browser and Playwright with suppressed failures preserved

Use a generic `BrowserConsumer<T>` functional interface so workflow lambdas can throw checked exceptions.

Name browser methods after the application root, for example:

```java
void openDashboard(BrowserConsumer<Dashboard> consumer) throws Exception;
void openAdminConsole(BrowserConsumer<AdminConsole> consumer) throws Exception;
void openApplication(BrowserConsumer<Application> consumer) throws Exception;
```

Prefer the domain-specific name when the application has a clear product name. Use `openApplication` only when no better name is available.

## Application Harness

Create a simple Docker-backed application harness.

Required behaviour:

- choose a free local port when none is configured
- allow the local port to be overridden with a system property
- allow the Docker image name to be overridden with a system property
- generate a unique container name for each test run
- run `docker run --detach --rm --name <name> --publish 127.0.0.1:<local-port>:<container-port> <image>`
- forward `docker logs --follow` to test output with an application-specific prefix
- poll until the application is ready or a timeout is reached
- fail fast if the container exits before readiness
- stop the container in `close()`
- tolerate cleanup when the container has already stopped

Use system property names based on the application name:

```text
<app>.port
<app>.container.image
```

Examples:

```text
dashboard.port
dashboard.container.image
admin.port
admin.container.image
```

If no application name is clear, use:

```text
application.port
application.container.image
```

Readiness should use the best stable signal available:

1. a documented health endpoint
2. a public route that returns `200`
3. a public route that returns `200` and contains stable user-visible text

Do not invent `/actuator/health`. Use it only when Spring Boot Actuator is present or documented.

Default the readiness timeout to 30 seconds unless repository evidence shows slower startup.

## Test Style

Write tests that read as workflows.

Good shape:

```java
browser.openApplication(application -> application.openDashboard()
        .shouldShowRecord("Request A")
        .startNewRequest()
        .enterRequester("user@example.com")
        .submit()
        .shouldShowConfirmation()
        .openAdminReview()
        .loginAs("admin", "very long and secure password")
        .shouldShowSubmittedRequest("user@example.com"));
```

Avoid this in test methods:

```java
page.navigate(baseUrl + "/dashboard");
page.locator("input[name=requester]").fill("user@example.com");
page.locator("button").click();
assertThat(page.content()).contains("Request A");
```

Low-level selectors belong in page objects or workflow classes.

Assertions should use stable user-observable behaviour:

- page headings and labels
- form submission results
- totals or calculated values
- table rows that represent business records
- downloaded or linked documents when they are part of the workflow
- successful navigation to a meaningful route

Avoid asserting incidental copy, layout text, repeated navigation labels, generated ids, timestamps, or broad page content unless they are the behaviour being characterized.

## Page Objects and Helpers

Keep page objects small and product-specific.

Use methods named after user actions and observable states:

- `openDashboard()`
- `startNewRequest()`
- `enterRequester(emailAddress)`
- `submit()`
- `loginAs(username, password)`
- `shouldShowConfirmation()`
- `shouldShowSubmittedRequest(...)`

Avoid names that expose implementation mechanics:

- `clickSubmitButton()`
- `fillInputByName(...)`
- `waitForSelector(...)`
- `assertDivContains(...)`

Split page objects by screen or workflow when one class starts mixing unrelated responsibilities. Do not split just to make every file small.

Use helper classes for parsing structured outputs such as XML, JSON, CSV, or generated documents when a workflow needs to assert their contents. Keep parsing behind fluent assertions, so the test remains readable.

## Workflow

1. Inspect the application, provided fixtures, and runbooks for functional behaviour.
2. Identify the smallest critical user workflows to characterize first.
3. Determine the Docker image name, container port, readiness signal, base package, and application name.
4. Create the standalone `functional-tests` Maven project.
5. Add browser harness classes.
6. Add the Docker-backed application harness.
7. Add domain root and page/workflow objects for the selected behaviours.
8. Add one or two functional test classes covering the selected workflows.
9. Compile the functional-test project.
10. If a Docker image can be built or already exists, run the functional tests.
11. Report assumptions, validation results, and any workflows that still need characterization.

## Validation

Before validation, confirm the active Java runtime is Java 25.

Minimum validation when a Maven wrapper is available in `functional-tests`:

```sh
cd functional-tests
./mvnw test
```

If the functional-test project does not include a Maven wrapper, use the repository wrapper when it can run the separate project directly, or use `mvn` from `functional-tests`:

```sh
cd functional-tests
mvn test
```

When Playwright browsers are not installed, run the Java Playwright installer from the functional-test project:

```sh
mvn exec:java -Dexec.mainClass=com.microsoft.playwright.CLI -Dexec.args="install chromium"
```

Only install Playwright browsers when needed for validation and when the environment allows downloads.

If Docker image creation is outside the current request, validate compilation and report the exact image property needed to run the tests later.

## Output

After creating or updating the harness, summarize:

- where the `functional-tests` project was created
- the Docker image property and default image name
- the local port property
- the readiness signal used
- workflows covered by tests
- validation commands run and results
- assumptions, blockers, or follow-up workflows

Do not claim the harness proves application behaviour unless the functional tests actually ran against a container.
