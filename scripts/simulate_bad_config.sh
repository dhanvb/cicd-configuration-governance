#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CONFIG_FILE="$ROOT_DIR/config-repo/app-config.yml"
TARGET_FILE="/tmp/cicd-configuration-governance/demo-app/app-config.yml"
EVIDENCE_FILE="$ROOT_DIR/examples/bad-config-failure.log"

BACKUP_FILE="$(mktemp)"

cleanup() {
    cp "$BACKUP_FILE" "$CONFIG_FILE"
    rm -f "$BACKUP_FILE"
}

trap cleanup EXIT

cp "$CONFIG_FILE" "$BACKUP_FILE"

echo "=== Establishing approved baseline ==="
"$ROOT_DIR/scripts/run_deployment.sh" >/dev/null

BASELINE_SHA="$(sha256sum "$TARGET_FILE" | awk '{print $1}')"

echo "Changing candidate version from 7.2 to 7.3."
sed -i 's/^version: .*/version: "7.3"/' "$CONFIG_FILE"

echo "Running governance pipeline with unapproved configuration."

set +e
"$ROOT_DIR/scripts/run_deployment.sh" >"$EVIDENCE_FILE" 2>&1
STATUS=$?
set -e

AFTER_SHA="$(sha256sum "$TARGET_FILE" | awk '{print $1}')"

if [[ "$STATUS" -eq 0 ]]; then
    echo "ERROR: Unapproved configuration was accepted."
    exit 1
fi

if ! grep -q "Pre-deployment validation failed" "$EVIDENCE_FILE"; then
    echo "ERROR: Pipeline failed, but not at the expected pre-deployment governance gate."
    exit 1
fi

if [[ "$BASELINE_SHA" != "$AFTER_SHA" ]]; then
    echo "ERROR: Target configuration changed during rejected deployment."
    exit 1
fi

echo "PASS: Unapproved configuration was rejected before deployment."
echo "PASS: Previously approved deployed state remained unchanged."
echo "Evidence: $EVIDENCE_FILE"

exit 0
