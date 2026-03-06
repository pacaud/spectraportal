#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Deploy
#
# Targets:
# - cdn:      deploy ./cdn/<version> and ./cdn/latest -> $WEBROOT_CDN
# - framework:deploy ./framework (excluding src/ + cdn/) -> $WEBROOT_FRAMEWORK
#             plus publish a root index.html for nginx.
#
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_deploy.sh cdn
#   scripts/sp_deploy.sh framework
# ============================================================

TARGET="${1:-cdn}"
: "${SP_CDN_VERSION:=v0.1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load deploy env (REMOTE + webroots). Missing keys fall back to defaults.
if [[ -f "$SCRIPT_DIR/sp_deploy.env" ]]; then
  # shellcheck disable=SC1091
  source "$SCRIPT_DIR/sp_deploy.env"
fi

: "${REMOTE:=root@100.121.30.60}"
: "${WEBROOT_CDN:=/var/www/cdn.spectraportal.dev}"
: "${WEBROOT_FRAMEWORK:=/var/www/framework.spectraportal.dev}"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CDN_SRC_VERSION="$REPO_ROOT/cdn/$SP_CDN_VERSION"
CDN_SRC_LATEST="$REPO_ROOT/cdn/latest"

rsync_push() {
  local SRC="$1"
  local DST="$2"
  rsync -av --delete "$SRC" "$DST"
}

if [[ "$TARGET" == "cdn" ]]; then
  echo "[deploy] pushing version + latest"

  if [[ ! -d "$CDN_SRC_VERSION" ]]; then
    echo "[deploy] ERROR: missing build output: $CDN_SRC_VERSION" >&2
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

  # Push framework site content, but keep sources OFF the server.
  rsync -av --delete     --exclude "src/"     --exclude "cdn/"     "$REPO_ROOT/framework/"     "$REMOTE:$WEBROOT_FRAMEWORK/"

  # Ensure framework webroot has a root index.html
  if [[ -f "$REPO_ROOT/index.html" ]]; then
    rsync -av "$REPO_ROOT/index.html" "$REMOTE:$WEBROOT_FRAMEWORK/index.html"
  elif [[ -f "$REPO_ROOT/framework/demos/index.html" ]]; then
    rsync -av "$REPO_ROOT/framework/demos/index.html" "$REMOTE:$WEBROOT_FRAMEWORK/index.html"
  else
    echo "[deploy] WARN: no index.html found to publish to framework webroot." >&2
  fi

  echo "[deploy] framework done"
  exit 0
fi

echo "[deploy] ERROR: unknown target: $TARGET" >&2
echo "[deploy] Valid targets: cdn | framework" >&2
exit 1
