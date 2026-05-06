#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: examples/run.sh <example-name>

Runs examples/sw-runbook.yaml with inputs from examples/<example-name> in a clean temporary directory.
Writes a shareable copy of the completed example to examples/dist/<example-name>.
Writes the completed solution directory to examples/dist/<example-name>/solution.zip.
EOF
}

list_examples() {
  find "${EXAMPLES_DIR}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

EXAMPLES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${EXAMPLES_DIR}/.." && pwd)"
EXAMPLE="$1"

if [[ ! "${EXAMPLE}" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "Invalid example name: ${EXAMPLE}" >&2
  echo "Use one of:" >&2
  list_examples >&2
  exit 2
fi

SOURCE_DIR="${EXAMPLES_DIR}/${EXAMPLE}"
RUNBOOK="${EXAMPLES_DIR}/sw-runbook.yaml"
PRODUCT_DESCRIPTION="${SOURCE_DIR}/product-description.md"
CREATE_SCOPE_ANSWERS="${SOURCE_DIR}/create-scope-answers.md"
PATH_TO_PRODUCTION_ANSWERS="${SOURCE_DIR}/path-to-production-answers.md"
ARCHITECTURE_DECISION_ANSWERS="${SOURCE_DIR}/architecture-decision-answers.md"
IMPLEMENTATION_TASKS_ANSWERS="${SOURCE_DIR}/implementation-tasks-answers.md"
TARGET_DIR="/tmp/${EXAMPLE}"
DIST_ROOT="${EXAMPLES_DIR}/dist"
DIST_DIR="${DIST_ROOT}/${EXAMPLE}"
RUNBOOK_FILE="${DIST_DIR}/runbook.md"
SOLUTION_ARCHIVE="${DIST_DIR}/solution.zip"
DIST_ARCHIVE="${DIST_ROOT}/${EXAMPLE}.zip"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Unknown example: ${EXAMPLE}" >&2
  echo "Use one of:" >&2
  list_examples >&2
  exit 2
fi

if [[ ! -f "${RUNBOOK}" ]]; then
  echo "Missing shared runbook: ${RUNBOOK}" >&2
  exit 2
fi

if [[ ! -f "${PRODUCT_DESCRIPTION}" ]]; then
  echo "Missing product description: ${PRODUCT_DESCRIPTION}" >&2
  exit 2
fi

if grep -q '@\.fixtures/prompts/create-scope-answers\.md' "${RUNBOOK}" && [[ ! -f "${CREATE_SCOPE_ANSWERS}" ]]; then
  echo "Missing create-scope answers: ${CREATE_SCOPE_ANSWERS}" >&2
  exit 2
fi

if grep -q '@\.fixtures/prompts/path-to-production-answers\.md' "${RUNBOOK}" && [[ ! -f "${PATH_TO_PRODUCTION_ANSWERS}" ]]; then
  echo "Missing path-to-production answers: ${PATH_TO_PRODUCTION_ANSWERS}" >&2
  exit 2
fi

if grep -q '@\.fixtures/prompts/architecture-decision-answers\.md' "${RUNBOOK}" && [[ ! -f "${ARCHITECTURE_DECISION_ANSWERS}" ]]; then
  echo "Missing architecture-decision answers: ${ARCHITECTURE_DECISION_ANSWERS}" >&2
  exit 2
fi

if grep -q '@\.fixtures/prompts/implementation-tasks-answers\.md' "${RUNBOOK}" && [[ ! -f "${IMPLEMENTATION_TASKS_ANSWERS}" ]]; then
  echo "Missing implementation-tasks answers: ${IMPLEMENTATION_TASKS_ANSWERS}" >&2
  exit 2
fi

# Ignore all the things within the dist directory.
mkdir -p "${DIST_ROOT}"
cat <<'EOF' > "${DIST_ROOT}/.gitignore"
*
EOF

# Recreate the target directory to simulate running the runbook in a clean environment.
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}/docs/product"
cp "${PRODUCT_DESCRIPTION}" "${TARGET_DIR}/docs/product/description.md"
if [[ -f "${CREATE_SCOPE_ANSWERS}" ]]; then
  mkdir -p "${TARGET_DIR}/.fixtures/prompts"
  cp "${CREATE_SCOPE_ANSWERS}" "${TARGET_DIR}/.fixtures/prompts/create-scope-answers.md"
fi
if [[ -f "${PATH_TO_PRODUCTION_ANSWERS}" ]]; then
  mkdir -p "${TARGET_DIR}/.fixtures/prompts"
  cp "${PATH_TO_PRODUCTION_ANSWERS}" "${TARGET_DIR}/.fixtures/prompts/path-to-production-answers.md"
fi
if [[ -f "${ARCHITECTURE_DECISION_ANSWERS}" ]]; then
  mkdir -p "${TARGET_DIR}/.fixtures/prompts"
  cp "${ARCHITECTURE_DECISION_ANSWERS}" "${TARGET_DIR}/.fixtures/prompts/architecture-decision-answers.md"
fi
if [[ -f "${IMPLEMENTATION_TASKS_ANSWERS}" ]]; then
  mkdir -p "${TARGET_DIR}/.fixtures/prompts"
  cp "${IMPLEMENTATION_TASKS_ANSWERS}" "${TARGET_DIR}/.fixtures/prompts/implementation-tasks-answers.md"
fi

# Copy the skills which are referred to from the runbook.
mkdir -p "${TARGET_DIR}/.fixtures"
cp -R "${REPO_ROOT}/skills" "${TARGET_DIR}/.fixtures/"
cat <<'EOF' > "${TARGET_DIR}/.fixtures/AGENTS.md"
# AGENTS.md

This directory is out of scope for normal repository work.

Do not inspect, summarize, edit, or rely on files in this directory unless a runbook or user prompt explicitly references a file here.

When a file in this directory is explicitly referenced, use only that referenced file and do not browse the surrounding fixture tree.
EOF

(cd "${TARGET_DIR}"

 # Create the distribution directory before running the runbook so sw can write
 # the rendered runbook output there directly.
 rm -rf "${DIST_DIR}"
 mkdir -p "${DIST_DIR}/.fixtures" "${DIST_DIR}/docs/product"

 # Run the runbook.
 sw run --input-file "${RUNBOOK}" --verbose --working-directory "${TARGET_DIR}" --output-file "${RUNBOOK_FILE}"

 cp "${TARGET_DIR}/.fixtures/AGENTS.md" "${DIST_DIR}/.fixtures/AGENTS.md"
 if [[ -d "${TARGET_DIR}/.fixtures/prompts" ]]; then
  cp -R "${TARGET_DIR}/.fixtures/prompts" "${DIST_DIR}/.fixtures/prompts"
 fi
 cp -R "${REPO_ROOT}/skills" "${DIST_DIR}/.fixtures/skills"
 cp "${PRODUCT_DESCRIPTION}" "${DIST_DIR}/docs/product/description.md"
 (cd "$(dirname "${TARGET_DIR}")" && zip -qr "${SOLUTION_ARCHIVE}" "${EXAMPLE}" -x '*/target/' '*/target/*')
 rm -f "${DIST_ARCHIVE}"
 (cd "${DIST_ROOT}" && zip -qr "${DIST_ARCHIVE}" "${EXAMPLE}")

 # Open the editor.
 code .
)
