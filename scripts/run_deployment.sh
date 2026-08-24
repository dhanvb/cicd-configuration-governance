#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

echo "=== Starting deployment ==="
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml

echo
echo "=== Starting validation ==="
ansible-playbook -i ansible/inventory.ini ansible/validate.yml

echo
echo "=== Deployment accepted ==="
