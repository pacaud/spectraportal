#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   scripts/sp_build.sh [target]
# Build is only required for targets that depend on npm build outputs.

TARGET="${1:-devhub}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "[build] target: $TARGET"
echo "[build] repo:   $REPO_ROOT"

case "$TARGET" in
  devhub|framework)
    if [[ -f package.json ]]; then
      echo "[build] running: npm run build:all"
      npm run build:all
      if [[ -d framework/cdn/v0.1 ]]; then
        echo "[build] outputs:"
        ls -la framework/cdn/v0.1
      else
        echo "[build] WARN: expected output missing: framework/cdn/v0.1" >&2
      fi
    else
      echo "[build] WARN: package.json not found; skipping npm build." >&2
    fi
    ;;
  portal|lab)
    echo "[build] skipping (no npm build required for target: $TARGET)"
    ;;
  *)
    echo "[build] ERROR: unknown target: $TARGET" >&2
    echo "[build] Valid targets: portal | devhub | framework | lab" >&2
    exit 1
    ;;
esac
