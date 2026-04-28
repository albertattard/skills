# Codex Skills

This repository contains software-development-focused Codex skills for turning
an early product idea into implementation-ready documentation.

The skills are intended to be reusable across projects. They are tested with
[`sw` runbooks](https://github.com/albertattard/sw) that apply the same skill
definitions to multiple example product descriptions, so changes should improve
the shared workflow rather than fit only one example.

## Skills

The repository currently provides five skills:

- `create-scope`: clarifies a product idea, challenges ambiguity, captures the
  first useful flow, and writes a scoped Markdown artefact.
- `derive-product-requirements-document`: turns an agreed scope into a practical
  Product Requirements Document (PRD).
- `derive-vertical-slices`: turns a PRD into ordered, user-visible vertical
  slice documents.
- `derive-path-to-production`: turns requirements, slices, and repository
  context into a production readiness and release sequencing plan.
- `derive-implementation-tasks`: turns vertical slices, production-readiness
  planning, and repository context into ordered implementation task documents.

Together, these skills support this workflow:

```text
product description
  -> scope
  -> product requirements document
  -> vertical slices
  -> path to production
  -> implementation tasks
```

## Repository Layout

```text
.
|-- AGENTS.md
|-- examples/
|   |-- run.sh
|   |-- sw-runbook.yaml
|   |-- poc-tracker/
|   `-- wort-werk/
`-- skills/
    |-- create-scope/
    |-- derive-implementation-tasks/
    |-- derive-path-to-production/
    |-- derive-product-requirements-document/
    `-- derive-vertical-slices/
```

- `skills/` contains the reusable Codex skill definitions and their agent
  metadata.
- `examples/` contains product-description fixtures and a shared `sw` runbook
  used to exercise the skills.
- `AGENTS.md` captures repository-specific development, validation, and
  commit-message expectations.

## Running Examples

Use the example runner with one of the available example names:

```sh
examples/run.sh poc-tracker
examples/run.sh wort-werk
```

The runner creates a clean temporary project under `/tmp/<example-name>`, copies
the shared runbook and skills into that project, runs `sw`, and then copies the
generated example README back into the example directory.

The examples require the tools checked by the runbook, including:

- Git
- Codex CLI
- Tree
- [`sw`](https://github.com/albertattard/sw)

## Development Notes

When changing a skill:

- Keep the skill generally useful across the examples.
- Prefer explicit, practical instructions over broad guidance that depends on
  implicit agent judgment.
- Treat ambiguity in skill behaviour as a design issue and clarify the skill
  text.
- Update examples when expected skill behaviour changes.
- Run both examples when a change affects shared workflow behaviour.

## License

This repository is licensed under the MIT License. See [`LICENSE`](LICENSE) for
the full license text.
