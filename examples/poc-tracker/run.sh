#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE="$(basename "${SOURCE_DIR}")"
TARGET_DIR="/tmp/${EXAMPLE}"

# Recreate the target directory to simulate running the runbook in a clean environment.
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"
cp "${SOURCE_DIR}/sw-runbook.yaml" "${TARGET_DIR}/sw-runbook.yaml"

# Copy the skills which are referred to from the runbook
mkdir -p "${TARGET_DIR}/.fixtures"
cp -R "${SOURCE_DIR}/../../skills" "${TARGET_DIR}/.fixtures/"
cat <<'EOF' > "${TARGET_DIR}/.fixtures/AGENTS.md"
# AGENTS.md

This directory is out of scope for normal repository work.

Do not inspect, summarize, edit, or rely on files in this directory under any circumstances.
EOF

(cd "${TARGET_DIR}"
 # Run the runbook
 sw --verbose

 cp "${TARGET_DIR}/README.md" "${SOURCE_DIR}/README.md"

 # Open the editor
 code .
)
