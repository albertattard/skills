---
name: create-oracle-java-dockerfile
description: Use when Codex needs to analyze a Java project and create or update a Dockerfile at a requested path or under containers/ by default, using Oracle Java images, a JLink custom runtime for Java 9 and later, container-aware JVM memory settings, a non-root user, and docker build validation.
---

# Create Oracle Java Dockerfile

## Overview

Create a Dockerfile for a Java application after inspecting the repository.

Hard rules:

* Write the Dockerfile to the path explicitly requested by the user. If no path is requested, use `containers/Dockerfile-Java<major-version>`, for example `containers/Dockerfile-Java8` or `containers/Dockerfile-Java17`.
* Create the Dockerfile parent directory if it does not exist.
* Use Oracle-published images.
* Use the Java version explicitly requested by the user. If none is requested, use the project's required Java version.
* For Java 8, use the Oracle JDK image directly because `jlink` is not available.
* For Java 9 and later, use a multi-stage `jlink` build by default.
* Copy only the packaged runtime artifact and required runtime files.
* Run the application as a non-root user unless the selected image makes that impossible.
* Put JVM options in `JAVA_TOOL_OPTIONS`.
* Do not create or update `.dockerignore`.
* Build the image with `docker build` as the validation gate. Do not run the container unless the user explicitly asks.

## Workflow

1. Inspect repository evidence to determine requested Dockerfile path, requested Java version, project Java version, packaging model, artifact path, port, health endpoint, package command, and target deployable module.
2. Ask before generating a Dockerfile when neither the user nor repository evidence identifies the Java version, or when the runtime artifact or target deployable module cannot be determined confidently.
3. If the user requests a Java version that differs from the project build version, treat the requested version as the container target. Do not silently change source or build configuration. Report the mismatch as a migration assumption and let Docker build validation prove whether the packaged artifact can be containerised on the requested Java version.
4. Package the application when needed so the artifact exists.
5. For Java 9 and later, detect required modules with `jdeps` or module metadata.
6. Determine the Dockerfile path: use the user-requested path when provided, otherwise use `containers/Dockerfile-Java<major-version>`.
7. Create the Dockerfile parent directory if missing.
8. Generate the Dockerfile.
9. Validate the Dockerfile content against the selected pattern.
10. Run `docker build` with the repository root as build context and the selected Dockerfile path.
11. Remove the locally built image after a successful build.
12. Do not run the container unless the user explicitly asks.
13. Report validation results, blockers, and assumptions.

Useful evidence includes build files, existing container assets, runtime configuration, package outputs under `target/` or `build/libs/`, documented artifact paths, and packaging-model clues such as Spring Boot, Quarkus, Micronaut, WAR, CLI, worker, native image, or multi-module structure.

Do not invent ports, health endpoints, profiles, startup parameters, or product-specific conventions.

## Oracle Images

Use Oracle Container Registry Java images:

```text
container-registry.oracle.com/java/jdk
```

Registry browser:

```text
https://container-registry.oracle.com/ords/ocr/ba/java/jdk
```

Choose a pinned Oracle JDK tag for the requested Java major version. If the user did not request one, use the project's Java major version.

Examples:

| Java version | Oracle JDK image |
| --- | --- |
| Java 8 | `container-registry.oracle.com/java/jdk:8u491` |
| Java 11 | `container-registry.oracle.com/java/jdk:11.0.31` |
| Java 17 | `container-registry.oracle.com/java/jdk:17.0.19` |
| Java 21 | `container-registry.oracle.com/java/jdk:21.0.11` |
| Java 25 | `container-registry.oracle.com/java/jdk:25.0.3` |

Avoid floating tags such as `latest`.

For Java 9 and later, use `container-registry.oracle.com/os/oraclelinux:10-slim` as the default final-stage image after copying in the custom runtime from the Oracle JDK builder.

## Java 8 Pattern

Use this pattern for executable JAR applications on Java 8:

```dockerfile
FROM container-registry.oracle.com/java/jdk:<tag>

RUN useradd --system --uid 10001 --create-home appuser

WORKDIR /opt/app

COPY --chown=appuser:appuser target/example.jar app.jar

USER appuser

EXPOSE 8080

ENV JAVA_TOOL_OPTIONS="-XX:MinRAMPercentage=75.0 -XX:MaxRAMPercentage=75.0"

ENTRYPOINT ["java", "-jar", "app.jar"]
```

Adapt the artifact path and `EXPOSE` value from repository evidence. Omit `EXPOSE` for non-networked CLI, batch, or worker applications.

## JLink Pattern

Use this pattern for executable JAR applications on Java 9 and later:

```dockerfile
FROM container-registry.oracle.com/java/jdk:<tag> AS jre-builder

WORKDIR /opt

RUN jlink \
    --add-modules <comma-separated-modules> \
    --no-header-files \
    --no-man-pages \
    --output /opt/java-runtime

FROM container-registry.oracle.com/os/oraclelinux:10-slim

RUN useradd --system --uid 10001 --create-home appuser

ENV JAVA_HOME=/opt/java-runtime
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV JAVA_TOOL_OPTIONS="-XX:MinRAMPercentage=75.0 -XX:MaxRAMPercentage=75.0"

WORKDIR /opt/app

COPY --from=jre-builder /opt/java-runtime /opt/java-runtime
COPY --chown=appuser:appuser target/example.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

Adapt the artifact path and `EXPOSE` value from repository evidence. Omit `EXPOSE` for non-networked CLI, batch, or worker applications.

Important `jlink` rules:

* `jlink --output` requires the parent directory to exist and the output directory itself to not exist.
* Do not include `--strip-debug` by default. Some Oracle JDK images do not include `objcopy`, which makes `jlink --strip-debug` fail.
* Do not include `--compress` by default.
* Add `--strip-debug`, compression, or package-manager installs only when repository evidence justifies the extra complexity and the image builds successfully.

## Detect JLink Modules

Package the application first, then detect modules with `jdeps`.

Plain executable JAR:

```sh
jdeps --multi-release <java-major-version> --ignore-missing-deps --print-module-deps target/app.jar
```

Spring Boot executable JAR:

```sh
mkdir -p /tmp/jdeps-app
cd /tmp/jdeps-app
jar xf /path/to/app.jar
jdeps --multi-release <java-major-version> --ignore-missing-deps --print-module-deps --class-path 'BOOT-INF/lib/*' BOOT-INF/classes
```

If the project has `module-info.java`, prefer the declared module graph and confirm it with `jdeps`.

`jdeps` can miss modules used through reflection, service loading, agents, JDBC drivers, scripting engines, or framework runtime behavior. Add modules only when required by repository evidence, `jdeps`, or build/runtime validation. If runtime execution is not requested, report that runtime-only module gaps may still need a later smoke test.

Common server-side modules may include:

```text
java.compiler
java.instrument
java.management
java.naming
java.security.jgss
java.sql
java.xml
jdk.unsupported
```

## JVM Options

Use `JAVA_TOOL_OPTIONS` for JVM options in both Java 8 and JLink images:

```dockerfile
ENV JAVA_TOOL_OPTIONS="-XX:MinRAMPercentage=75.0 -XX:MaxRAMPercentage=75.0"
```

When adding options with values, prefer single-token forms. For example, use:

```text
--add-opens=java.base/java.lang=ALL-UNNAMED
```

inside `JAVA_TOOL_OPTIONS`, not the two-token command-line form:

```text
--add-opens java.base/java.lang=ALL-UNNAMED
```

Add extra JVM flags only when repository evidence or the user justifies them.

## Health Checks

Add `HEALTHCHECK` only when repository evidence supports it.

Use `/actuator/health` for Spring Boot Actuator. Use another endpoint only when documented. Do not invent a health endpoint.

Before using `curl` or `wget`, confirm the selected runtime image contains the tool. Do not install packages solely for a health check unless the repository explicitly requires it and the package-manager command is known to work.

If no suitable health-check mechanism exists, omit `HEALTHCHECK` and report why.

## Packaging Variants

Do not force every project into `java -jar app.jar`.

* WAR deployments: keep the repository's deployment model.
* Quarkus: follow the configured package mode, such as fast-jar, uber-jar, mutable-jar, or native.
* Native images: generate a container for the native executable, not a Java runtime Dockerfile.
* Multi-module builds: copy only the artifact for the selected deployable module.

## Validation

Docker build validation is mandatory for a completed Dockerfile task unless blocked by the execution environment, Docker daemon, Oracle registry access, network access, or a missing packaged artifact.

Use commands like:

```sh
./mvnw package
docker build -f <dockerfile-path> -t <app-name>:local .
docker image rm <app-name>:local
```

If `docker build` fails with an approval or execution-policy error such as `command execution approval is not supported in exec mode` or `Rejected("rejected by user")`, treat that as an execution-environment blocker. Do not claim the Dockerfile is build-validated.

If Docker build cannot run, perform static validation and clearly state that it is a fallback, not a substitute for Docker build validation.

Static validation checks:

* artifact path exists after packaging
* selected Oracle JDK image matches the requested Java version, or the project Java version when no version was requested
* Java 9 and later Dockerfiles use a `jlink` builder stage unless there is a documented reason not to
* `jlink --output` parent directory exists and the output directory itself is not pre-created
* no default `--strip-debug` or `--compress`
* detected module list is recorded, or manual adjustments are explained
* exposed port matches repository configuration
* health-check decision matches repository evidence
* JVM memory flags are present in `JAVA_TOOL_OPTIONS`
* startup command matches the packaging model
* non-root user is used, or the reason it could not be used is reported

Final report:

* Dockerfile path
* selected Oracle JDK image
* selected runtime base image, when applicable
* requested Java version
* project Java version, when different from the requested version
* artifact path
* packaging model
* exposed ports
* health-check decision
* validation commands executed
* Docker build result and image cleanup result
* assumptions and follow-up actions
