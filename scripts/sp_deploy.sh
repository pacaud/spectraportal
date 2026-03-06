#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Deploy
#
# Targets:
# - cdn:       deploy ./cdn/<version> and ./cdn/latest -> $WEBROOT_CDN
# - assets:    deploy ./assets -> $WEBROOT_ASSETS
# - framework: deploy ./framework -> $WEBROOT_FRAMEWORK
# - dev:       deploy ./docs -> $WEBROOT_DEV
# - docs:      compatibility alias for dev
#
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_deploy.sh cdn
#   scripts/sp_deploy.sh assets
#   scripts/sp_deploy.sh framework
#   scripts/sp_deploy.sh dev
#   scripts/sp_deploy.sh docs   # compatibility alias
# ============================================================

TARGET="${1:-cdn}"
: "${SP_CDN_VERSION:=v0.1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/sp_deploy.env" ]]; then
  # shellcheck disable=SC1091
  source "$SCRIPT_DIR/sp_deploy.env"
fi

: "${REMOTE:=root@100.121.30.60}"
: "${WEBROOT_DEV:=/var/www/spectraportal.dev}"
: "${WEBROOT_DOCS:=$WEBROOT_DEV}"
: "${WEBROOT_FRAMEWORK:=/var/www/framework.spectraportal.dev}"
: "${WEBROOT_CDN:=/var/www/cdn.spectraportal.dev}"
: "${WEBROOT_ASSETS:=/var/www/assets.spectraportal.dev}"
: "${WEBROOT_GATE:=/var/www/gate.spectraportal.dev}"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CDN_SRC_VERSION="$REPO_ROOT/cdn/$SP_CDN_VERSION"
CDN_SRC_LATEST="$REPO_ROOT/cdn/latest"
ASSETS_SRC="$REPO_ROOT/assets"
FRAMEWORK_SRC="$REPO_ROOT/framework"
DOCS_SRC="$REPO_ROOT/docs"

# Normalize old target name.
if [[ "$TARGET" == "docs" ]]; then
  echo "[deploy] alias: docs -> dev"
  TARGET="dev"
fi

rsync_push() {
  local SRC="$1"
  local DST="$2"
  rsync -av --delete "$SRC" "$DST"
}

remote_mkdir() {
  local DST="$1"
  ssh "$REMOTE" "mkdir -p '$DST'"
}

if [[ "$TARGET" == "cdn" ]]; then
  echo "[deploy] cdn: pushing version + latest"

  if [[ ! -d "$CDN_SRC_VERSION" ]]; then
    echo "[deploy] ERROR: missing build output: $CDN_SRC_VERSION" >&2
    echo "  Run: SP_CDN_VERSION=$SP_CDN_VERSION scripts/sp_build.sh cdn" >&2
    exit 1
  fi

  if [[ ! -d "$CDN_SRC_LATEST" ]]; then
    echo "[deploy] ERROR: missing latest build output: $CDN_SRC_LATEST" >&2
    echo "  Run: SP_CDN_VERSION=$SP_CDN_VERSION scripts/sp_build.sh cdn" >&2
    exit 1
  fi

  remote_mkdir "$WEBROOT_CDN/$SP_CDN_VERSION"
  remote_mkdir "$WEBROOT_CDN/latest"

  rsync_push "$CDN_SRC_VERSION/" "$REMOTE:$WEBROOT_CDN/$SP_CDN_VERSION/"
  rsync_push "$CDN_SRC_LATEST/"  "$REMOTE:$WEBROOT_CDN/latest/"

  echo "[deploy] CDN done"
  exit 0
fi

if [[ "$TARGET" == "assets" ]]; then
  echo "[deploy] assets -> assets.spectraportal.dev"

  if [[ ! -d "$ASSETS_SRC" ]]; then
    echo "[deploy] ERROR: missing assets source: $ASSETS_SRC" >&2
    exit 1
  fi

  remote_mkdir "$WEBROOT_ASSETS"
  rsync_push "$ASSETS_SRC/" "$REMOTE:$WEBROOT_ASSETS/"

  echo "[deploy] assets done"
  exit 0
fi

if [[ "$TARGET" == "framework" ]]; then
  echo "[deploy] framework"

  if [[ ! -d "$FRAMEWORK_SRC" ]]; then
    echo "[deploy] ERROR: missing framework source: $FRAMEWORK_SRC" >&2
    exit 1
  fi

  remote_mkdir "$WEBROOT_FRAMEWORK"
  rsync_push "$FRAMEWORK_SRC/" "$REMOTE:$WEBROOT_FRAMEWORK/"

  echo "[deploy] framework done"
  exit 0
fi

if [[ "$TARGET" == "dev" ]]; then
  echo "[deploy] dev -> spectraportal.dev"

  if [[ ! -d "$DOCS_SRC" ]]; then
    echo "[deploy] ERROR: missing docs source: $DOCS_SRC" >&2
    exit 1
  fi

  remote_mkdir "$WEBROOT_DEV"
  rsync_push "$DOCS_SRC/" "$REMOTE:$WEBROOT_DEV/"

  echo "[deploy] dev done"
  exit 0
fi

echo "[deploy] ERROR: unknown target: $TARGET" >&2
echo "[deploy] Valid targets: cdn | assets | framework | dev" >&2
echo "[deploy] Legacy alias still supported: docs -> dev" >&2
exit 1
