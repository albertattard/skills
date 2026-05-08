#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: examples/run.sh <example-name>

Runs examples/sw-runbook.yaml with inputs from examples/<example-name> in a clean temporary directory.
Writes a shareable copy of the completed example to examples/dist/<example-name>.
Writes the completed repository directory to examples/dist/<example-name>/solution.zip.
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

prepare_example_layout() {
  local destination="$1"
  local repository="${destination}/repository"
  local fixtures="${destination}/fixtures"

  rm -rf "${destination}"

  # Copy the product description into the path used by the runbook.
  mkdir -p "${repository}/docs/product"
  cp "${PRODUCT_DESCRIPTION}" "${repository}/docs/product/description.md"

  # Copy prepared answers used when running the prompt-driven sections.
  mkdir -p "${fixtures}/prompts"
  cp "${CREATE_SCOPE_ANSWERS}"                  "${fixtures}/prompts/create-scope-answers.md"
  cp "${DERIVE_PRD_ANSWERS}"                    "${fixtures}/prompts/derive-product-requirements-document-answers.md"
  cp "${DERIVE_VERTICAL_SLICES_ANSWERS}"        "${fixtures}/prompts/derive-vertical-slices-answers.md"
  cp "${DERIVE_PATH_TO_PRODUCTION_ANSWERS}"     "${fixtures}/prompts/derive-path-to-production-answers.md"
  cp "${CAPTURE_ARCHITECTURE_DECISION_ANSWERS}" "${fixtures}/prompts/capture-architecture-decision-answers.md"
  cp "${DERIVE_IMPLEMENTATION_TASKS_ANSWERS}"   "${fixtures}/prompts/derive-implementation-tasks-answers.md"

  # Copy the skills which are referred to from the runbook.
  cp -R "${REPO_ROOT}/skills" "${fixtures}/"
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
DERIVE_PRD_ANSWERS="${SOURCE_DIR}/derive-product-requirements-document-answers.md"
DERIVE_VERTICAL_SLICES_ANSWERS="${SOURCE_DIR}/derive-vertical-slices-answers.md"
DERIVE_PATH_TO_PRODUCTION_ANSWERS="${SOURCE_DIR}/derive-path-to-production-answers.md"
CAPTURE_ARCHITECTURE_DECISION_ANSWERS="${SOURCE_DIR}/capture-architecture-decision-answers.md"
DERIVE_IMPLEMENTATION_TASKS_ANSWERS="${SOURCE_DIR}/derive-implementation-tasks-answers.md"
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

# Verify that the required fixtures files are available
require_file "shared runbook"                               "${RUNBOOK}"
require_file "product description"                          "${PRODUCT_DESCRIPTION}"
require_file "create scope answers"                         "${CREATE_SCOPE_ANSWERS}"
require_file "derive product requirements document answers" "${DERIVE_PRD_ANSWERS}"
require_file "derive vertical slices answers"               "${DERIVE_VERTICAL_SLICES_ANSWERS}"
require_file "derive path-to-production answers"            "${DERIVE_PATH_TO_PRODUCTION_ANSWERS}"
require_file "capture architecture-decision answers"        "${CAPTURE_ARCHITECTURE_DECISION_ANSWERS}"
require_file "derive implementation-tasks answers"          "${DERIVE_IMPLEMENTATION_TASKS_ANSWERS}"

# Ignore all the things within the dist directory.
mkdir -p "${DIST_ROOT}"
cat <<'EOF' > "${DIST_ROOT}/.gitignore"
*
EOF

# Recreate the directories used for the execution workspace and distributable copy.
prepare_example_layout "${TARGET_DIR}"
prepare_example_layout "${DIST_DIR}"
rm -f "${DIST_ARCHIVE}"

# Run the runbook.
sw run --verbose --input-file "${RUNBOOK}" --working-directory "${TARGET_DIR}/repository" --output-file "${RUNBOOK_FILE}"

# Package the completed project and the shareable example directory.
(cd "${TARGET_DIR}" && zip -qr "${SOLUTION_ARCHIVE}" repository -x '*/target/' '*/target/*' '*.DS_Store' '*/.DS_Store')
(cd "${DIST_ROOT}" && zip -qr "${DIST_ARCHIVE}" "${EXAMPLE}" -x '*.DS_Store' '*/.DS_Store')

# Open the editor.
code "${TARGET_DIR}/repository"
