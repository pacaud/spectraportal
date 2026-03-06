#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Deploy
#
# Targets:
# - cdn:       deploy ./cdn/<version> and ./cdn/latest -> $WEBROOT_CDN
# - framework: deploy ./framework -> $WEBROOT_FRAMEWORK
#              (excluding raw source folders)
# - docs:      deploy ./docs -> $WEBROOT_PORTAL
# - demos:     deploy ./demos -> $WEBROOT_LAB
#
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_deploy.sh cdn
#   scripts/sp_deploy.sh framework
#   scripts/sp_deploy.sh docs
#   scripts/sp_deploy.sh demos
# ============================================================

TARGET="${1:-cdn}"
: "${SP_CDN_VERSION:=v0.1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/sp_deploy.env" ]]; then
  # shellcheck disable=SC1091
  source "$SCRIPT_DIR/sp_deploy.env"
fi

: "${REMOTE:=root@100.121.30.60}"
: "${WEBROOT_DOCS:=/var/www/spectraportal.dev}"
: "${WEBROOT_FRAMEWORK:=/var/www/framework.spectraportal.dev}"
: "${WEBROOT_CDN:=/var/www/cdn.spectraportal.dev}"
: "${WEBROOT_GATE:=/var/www/gate.spectraportal.dev}"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CDN_SRC_VERSION="$REPO_ROOT/cdn/$SP_CDN_VERSION"
CDN_SRC_LATEST="$REPO_ROOT/cdn/latest"

rsync_push() {
  local SRC="$1"
  local DST="$2"
  rsync -av --delete "$SRC" "$DST"
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

  rsync_push "$CDN_SRC_VERSION/" "$REMOTE:$WEBROOT_CDN/$SP_CDN_VERSION/"
  rsync_push "$CDN_SRC_LATEST/"  "$REMOTE:$WEBROOT_CDN/latest/"

  echo "[deploy] CDN done"
  exit 0
fi

if [[ "$TARGET" == "framework" ]]; then
  echo "[deploy] framework"

  rsync -av --delete \
    --exclude "src/" \
    "$REPO_ROOT/framework/" \
    "$REMOTE:$WEBROOT_FRAMEWORK/"

  echo "[deploy] framework done"
  exit 0
fi

if [[ "$TARGET" == "docs" ]]; then
echo "[deploy] docs -> spectraportal.dev"

rsync -av --delete \
  "$REPO_ROOT/docs/" \
  "$REMOTE:$WEBROOT_DOCS/"

  echo "[deploy] docs done"
  exit 0
fi

if [[ "$TARGET" == "demos" ]]; then
  echo "[deploy] demos -> lab"

  rsync -av --delete \
    "$REPO_ROOT/demos/" \
    "$REMOTE:$WEBROOT_LAB/"

  echo "[deploy] demos done"
  exit 0
fi

echo "[deploy] ERROR: unknown target: $TARGET" >&2
echo "[deploy] Valid targets: cdn | framework | docs | demos" >&2
exit 1