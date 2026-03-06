#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-cdn}"
: "${SP_CDN_VERSION:=v0.1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/sp_deploy.env"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CDN_SRC_VERSION="$REPO_ROOT/cdn/$SP_CDN_VERSION"
CDN_SRC_LATEST="$REPO_ROOT/cdn/latest"

if [[ "$TARGET" == "cdn" ]]; then
  echo "[deploy] pushing version + latest"

  rsync -av --delete "$CDN_SRC_VERSION/" "$REMOTE:$WEBROOT_CDN/$SP_CDN_VERSION/"
  rsync -av --delete "$CDN_SRC_LATEST/" "$REMOTE:$WEBROOT_CDN/latest/"

  echo "[deploy] CDN done"
  exit 0
fi

if [[ "$TARGET" == "framework" ]]; then
  echo "[deploy] framework"

  rsync -av --delete     --exclude "src"     --exclude "framework/cdn"     "$REPO_ROOT/framework/"     "$REMOTE:$WEBROOT_FRAMEWORK/"

  echo "[deploy] framework done"
  exit 0
fi

echo "[deploy] unknown target"
