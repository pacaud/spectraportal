#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "[build] repo: $REPO_ROOT"
echo "[build] running: npm run build:all"
npm run build:all

echo "[build] outputs:"
ls -la framework/cdn/v0.1