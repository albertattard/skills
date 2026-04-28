# AGENTS.md

## Project Context

This repository contains software-development-focused Codex skills. The skills are still being tested, and `sw` runbooks are used to run multiple examples against the same skill definitions.

When changing a skill, keep the skill reusable across examples. Avoid adding assumptions that only satisfy one example unless the skill is explicitly intended to be example-specific.

## Skill Development

- Prefer clear, practical instructions that a coding agent can follow without extra interpretation.
- Keep skills focused on software development workflows and avoid broad, generic guidance unless it directly supports those workflows.
- Update examples when skill behavior changes in a way that affects expected usage.
- Treat ambiguity in skill behavior as a design issue: clarify the instructions instead of relying on implicit agent judgment.

## Validation

Use the existing `sw` examples to validate skill changes. When a change affects shared skill behavior, run both examples that exercise the same skills and compare whether the outcomes remain consistent with the intended behavior.

## Commit Messages

Keep commits coherent. Each commit should contain one logical change, and unrelated repository workflow changes should be committed separately.

When proposing commit messages, use:

- A short imperative subject line that starts with a verb.
- A body paragraph that explains why the change exists.
- Focus the body on motivation, context, or intent that cannot be determined from the diff. Avoid restating files changed or implementation details that are already visible in the commit.
