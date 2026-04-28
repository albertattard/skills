#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLE="$(basename "${SOURCE_DIR}")"
TARGET_DIR="/tmp/${EXAMPLE}"

# Recreate the target directory to simulate running the runbook in a clean environment.
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"
cp "${SOURCE_DIR}/sw-runbook.yaml" "${TARGET_DIR}/sw-runbook.yaml"

(cd "${TARGET_DIR}"
 # Run the runbook
 sw --verbose

 cp "${TARGET_DIR}/README.md" "${SOURCE_DIR}/README.md"

 # Open the editor
 code .
)
