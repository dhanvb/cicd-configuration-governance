#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/config-repo/app-config.yml"
EVIDENCE_FILE="$ROOT_DIR/examples/bad-config-failure.log"

cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

echo "Changing config version from 7.2 to 7.3 to simulate an unapproved config."
sed -i 's/^version: .*/version: 7.3/' "$CONFIG_FILE"

set +e
"$ROOT_DIR/scripts/run_deployment.sh" > "$EVIDENCE_FILE" 2>&1
STATUS=$?
set -e

mv "$CONFIG_FILE.bak" "$CONFIG_FILE"

echo "Simulation finished with exit code: $STATUS"
echo "Original config restored."
echo "Failure evidence written to: $EVIDENCE_FILE"

exit 0
