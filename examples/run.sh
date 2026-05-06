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

require_file() {
  local description="$1"
  local path="$2"

  if [[ ! -f "${path}" ]]; then
    echo "Missing ${description}: ${path}" >&2
    exit 2
  fi
}

prepare_example_directory() {
  local destination="$1"

  rm -rf "${destination}"

  # Add fixture instructions so copied support files stay out of normal project work.
  mkdir -p "${destination}/.fixtures"
  cat <<'EOF' > "${destination}/.fixtures/AGENTS.md"
# AGENTS.md

This directory is out of scope for normal repository work.

Do not inspect, summarize, edit, or rely on files in this directory unless a runbook or user prompt explicitly references a file here.

When a file in this directory is explicitly referenced, use only that referenced file and do not browse the surrounding fixture tree.
EOF

  # Copy the product description into the path used by the runbook.
  mkdir -p "${destination}/docs/product"
  cp "${PRODUCT_DESCRIPTION}" "${destination}/docs/product/description.md"

  # Copy prepared answers used when running the prompt-driven sections.
  mkdir -p "${destination}/.fixtures/prompts"
  cp "${CREATE_SCOPE_ANSWERS}"          "${destination}/.fixtures/prompts/create-scope-answers.md"
  cp "${PATH_TO_PRODUCTION_ANSWERS}"    "${destination}/.fixtures/prompts/path-to-production-answers.md"
  cp "${ARCHITECTURE_DECISION_ANSWERS}" "${destination}/.fixtures/prompts/architecture-decision-answers.md"
  cp "${IMPLEMENTATION_TASKS_ANSWERS}"  "${destination}/.fixtures/prompts/implementation-tasks-answers.md"

  # Copy the skills which are referred to from the runbook.
  cp -R "${REPO_ROOT}/skills" "${destination}/.fixtures/"
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

require_file "shared runbook"                "${RUNBOOK}"
require_file "product description"           "${PRODUCT_DESCRIPTION}"
require_file "create-scope answers"          "${CREATE_SCOPE_ANSWERS}"
require_file "path-to-production answers"    "${PATH_TO_PRODUCTION_ANSWERS}"
require_file "architecture-decision answers" "${ARCHITECTURE_DECISION_ANSWERS}"
require_file "implementation-tasks answers"  "${IMPLEMENTATION_TASKS_ANSWERS}"

# Ignore all the things within the dist directory.
mkdir -p "${DIST_ROOT}"
cat <<'EOF' > "${DIST_ROOT}/.gitignore"
*
EOF

# Recreate the directories used for the execution workspace and distributable copy.
prepare_example_directory "${TARGET_DIR}"
prepare_example_directory "${DIST_DIR}"

# Run the runbook.
sw run --verbose --input-file "${RUNBOOK}" --working-directory "${TARGET_DIR}" --output-file "${RUNBOOK_FILE}"

# Package the completed project and the shareable example directory.
(cd "$(dirname "${TARGET_DIR}")" && zip -qr "${SOLUTION_ARCHIVE}" "${EXAMPLE}" -x '*/target/' '*/target/*' '*.DS_Store' '*/.DS_Store')
rm -f "${DIST_ARCHIVE}"
(cd "${DIST_ROOT}" && zip -qr "${DIST_ARCHIVE}" "${EXAMPLE}" -x '*.DS_Store' '*/.DS_Store')

# Open the editor.
code "${TARGET_DIR}"
