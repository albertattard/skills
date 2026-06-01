# Scripts

This directory contains helper scripts for working with the shared skills in
this repository.

## Install A Skill From GitHub

Use [`install-skill-from-github`](install-skill-from-github) to install a skill
from a GitHub repository into a local agentic-tool skill directory.

By default, the installer:

- downloads skills from `albertattard/skills`
- installs from the `main` branch
- treats `--skill create-scope` as `--path skills/create-scope`
- targets Codex
- installs into the repository-local skill directory

### Codex

Codex is the default target, so this installs `create-scope` into
`.codex/skills/create-scope`:

```sh
curl -fsSL 'https://raw.githubusercontent.com/albertattard/skills/main/scripts/install-skill-from-github' | java --source 25 /dev/stdin \
  --skill create-scope
```

### GitHub Copilot

Use `--tool copilot` to install the same skill into
`.github/skills/create-scope`:

```sh
curl -fsSL 'https://raw.githubusercontent.com/albertattard/skills/main/scripts/install-skill-from-github' | java --source 25 /dev/stdin \
  --tool copilot \
  --skill create-scope
```

Run the installer with `--help` to see all supported options.
