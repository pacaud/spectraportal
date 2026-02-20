#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

ENV_FILE="$REPO_ROOT/scripts/sp_deploy.env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

: "${REMOTE:?Set REMOTE in scripts/sp_deploy.env (e.g. root@server)}"
: "${WEBROOT:?Set WEBROOT in scripts/sp_deploy.env (e.g. /var/www/spectraportal.dev)}"

echo "[deploy] remote:  $REMOTE"
echo "[deploy] webroot: $WEBROOT"

# Ensure targets exist
ssh "$REMOTE" "mkdir -p \
  '$WEBROOT/framework/cdn/v0.1' \
  '$WEBROOT/framework/demos' \
  '$WEBROOT/framework/docs' \
"

# 1) CDN CSS
rsync -av --delete \
  framework/cdn/v0.1/ \
  "$REMOTE:$WEBROOT/framework/cdn/v0.1/"

# 2) Demos
if [[ -d framework/demos ]]; then
  rsync -av --delete \
    framework/demos/ \
    "$REMOTE:$WEBROOT/framework/demos/"
fi

# 3) Docs (optional)
if [[ -d framework/docs ]]; then
  rsync -av --delete \
    framework/docs/ \
    "$REMOTE:$WEBROOT/framework/docs/"
fi

echo "[deploy] done."