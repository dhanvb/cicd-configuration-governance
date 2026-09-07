#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

echo "=== Pre-deployment governance validation ==="

if ! ansible-playbook \
  -i ansible/inventory.ini \
  ansible/pre_validate.yml
then
  echo
  echo "=== Deployment blocked ==="
  echo "Candidate configuration does not match the approved baseline."
  exit 1
fi

echo
echo "=== Governance approved candidate ==="

echo
echo "=== Deploy approved configuration ==="
ansible-playbook \
  -i ansible/inventory.ini \
  ansible/deploy.yml

echo
echo "=== Post-deployment verification ==="

if ! ansible-playbook \
  -i ansible/inventory.ini \
  ansible/post_validate.yml
then
  echo
  echo "=== Deployment verification failed ==="
  echo "The deployed configuration could not be proven to match the approved baseline."
  exit 1
fi

echo
echo "=== Deployment accepted ==="

