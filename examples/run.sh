#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: examples/run.sh <example-name>

Runs examples/sw-runbook.yaml with inputs from examples/<example-name> in a clean temporary directory.
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
TARGET_DIR="/tmp/${EXAMPLE}"

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

# Recreate the target directory to simulate running the runbook in a clean environment.
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"
cp "${RUNBOOK}" "${TARGET_DIR}/sw-runbook.yaml"
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
 # Run the runbook.
 sw --verbose

 cp "${TARGET_DIR}/README.md" "${SOURCE_DIR}/README.md"

 # Open the editor.
 code .
)
