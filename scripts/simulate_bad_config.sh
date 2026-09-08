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

echo "Changing candidate content while keeping approved version unchanged."
sed -i 's/^owner: .*/owner: unapproved-team/' "$CONFIG_FILE"

if ! grep -q '^version: "7.2"$' "$CONFIG_FILE"; then
    echo "ERROR: Negative test unexpectedly changed the approved version."
    exit 1
fi

echo "Running governance pipeline with same-version unapproved configuration."

set +e
"$ROOT_DIR/scripts/run_deployment.sh" >"$EVIDENCE_FILE" 2>&1
STATUS=$?
set -e

AFTER_SHA="$(sha256sum "$TARGET_FILE" | awk '{print $1}')"

if [[ "$STATUS" -eq 0 ]]; then
    echo "ERROR: Unapproved configuration was accepted."
    exit 1
fi

if ! grep -q "Pre-deployment governance validation failed" "$EVIDENCE_FILE"; then
    echo "ERROR: Pipeline failed, but not at the expected pre-deployment governance gate."
    exit 1
fi

if [[ "$BASELINE_SHA" != "$AFTER_SHA" ]]; then
    echo "ERROR: Target configuration changed during rejected deployment."
    exit 1
fi

echo "PASS: Same-version configuration tampering was rejected before deployment."
echo "PASS: Previously approved deployed state remained unchanged."
echo "Evidence: $EVIDENCE_FILE"

exit 0
