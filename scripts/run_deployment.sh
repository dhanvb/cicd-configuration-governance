#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

echo "=== Pre-deployment validation ==="
ansible-playbook \
  -i ansible/inventory.ini \
  ansible/pre_validate.yml

echo
echo "=== Deploy approved configuration ==="
ansible-playbook \
  -i ansible/inventory.ini \
  ansible/deploy.yml

echo
echo "=== Post-deployment verification ==="
ansible-playbook \
  -i ansible/inventory.ini \
  ansible/post_validate.yml

echo
echo "=== Deployment accepted ==="
