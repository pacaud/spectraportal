#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Deploy
#
# Targets:
# - cdn:        deploy ./cdn/<version> and ./cdn/latest -> $WEBROOT_CDN
# - assets:     deploy ./assets -> $WEBROOT_ASSETS
# - framework:  deploy ./framework -> $WEBROOT_FRAMEWORK
# - dev:        deploy ./docs -> $WEBROOT_DEV
# - gate:       deploy ./gate -> $WEBROOT_GATE (excluding boot/, chat_center/, core/)
# - gate-draft: deploy ./gate/drafts -> $WORKSPACE_GATE_DRAFTS
# - srv:        deploy ./gate/boot ./gate/chat_center ./gate/core -> /srv/spectraportal
# - docs:       compatibility alias for dev
#
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_deploy.sh cdn
#   scripts/sp_deploy.sh gate --repo /path/to/repo
#   scripts/sp_deploy.sh gate --repo /path/to/repo --src gate
#   scripts/sp_deploy.sh gate-draft --repo /path/to/repo
#   scripts/sp_deploy.sh gate-draft --repo /path/to/repo --src gate/drafts
#   scripts/sp_deploy.sh srv --repo /path/to/repo
#   scripts/sp_deploy.sh dev --repo /path/to/repo --src docs
# ============================================================

usage() {
  cat <<'EOF'
Usage:
  sp_deploy.sh <target> [--repo PATH] [--src PATH]

Targets:
  cdn         Deploy repo/cdn/<version> and repo/cdn/latest
  assets      Deploy repo/assets by default
  framework   Deploy repo/framework by default
  dev         Deploy repo/docs by default
  gate        Deploy repo/gate by default (excluding boot/, chat_center/, core/)
  gate-draft  Deploy repo/gate/drafts by default
  srv         Deploy repo/gate/boot, repo/gate/chat_center, repo/gate/core to /srv/spectraportal
  docs        Alias of dev

Options:
  --repo PATH Repo root to use instead of the parent of this script
  --src PATH  Source folder override for assets/framework/dev/gate/gate-draft
              (not used for srv)
              Absolute paths are allowed; relative paths are resolved under --repo
EOF
}

TARGET=""
REPO_OVERRIDE=""
SRC_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --repo)
      [[ $# -ge 2 ]] || { echo "[deploy] ERROR: --repo requires a path" >&2; exit 1; }
      REPO_OVERRIDE="$2"
      shift 2
      ;;
    --src)
      [[ $# -ge 2 ]] || { echo "[deploy] ERROR: --src requires a path" >&2; exit 1; }
      SRC_OVERRIDE="$2"
      shift 2
      ;;
    --*)
      echo "[deploy] ERROR: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
      else
        echo "[deploy] ERROR: unexpected argument: $1" >&2
        usage >&2
        exit 1
      fi
      shift
      ;;
  esac
done

TARGET="${TARGET:-cdn}"
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
: "${WORKSPACE_ROOT:=/srv/spectraportal/workspace/site}"
: "${WORKSPACE_GATE_DRAFTS:=$WORKSPACE_ROOT/gate/drafts}"
: "${SRV_ROOT:=/srv/spectraportal}"
: "${SRV_BOOT:=$SRV_ROOT/boot}"
: "${SRV_CHAT_CENTER:=$SRV_ROOT/chat_center}"
: "${SRV_CORE:=$SRV_ROOT/core}"

if [[ -n "$REPO_OVERRIDE" ]]; then
  REPO_ROOT="$(cd "$REPO_OVERRIDE" && pwd)"
else
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

resolve_src() {
  local default_rel="$1"
  if [[ -n "$SRC_OVERRIDE" ]]; then
    if [[ "$SRC_OVERRIDE" = /* ]]; then
      printf '%s\n' "$SRC_OVERRIDE"
    else
      printf '%s\n' "$REPO_ROOT/$SRC_OVERRIDE"
    fi
  else
    printf '%s\n' "$REPO_ROOT/$default_rel"
  fi
}

CDN_SRC_VERSION="$REPO_ROOT/cdn/$SP_CDN_VERSION"
CDN_SRC_LATEST="$REPO_ROOT/cdn/latest"

if [[ "$TARGET" == "docs" ]]; then
  echo "[deploy] alias: docs -> dev"
  TARGET="dev"
fi

rsync_push() {
  local SRC="$1"
  local DST="$2"
  rsync -av --delete "$SRC" "$DST"
}

rsync_push_filtered() {
  local SRC="$1"
  local DST="$2"
  shift 2 || true
  rsync -av --delete "$@" "$SRC" "$DST"
}

remote_mkdir() {
  local DST="$1"
  ssh "$REMOTE" "mkdir -p '$DST'"
}

if [[ "$TARGET" == "cdn" ]]; then
  echo "[deploy] cdn: pushing version + latest"
  echo "[deploy] repo: $REPO_ROOT"

  if [[ ! -d "$CDN_SRC_VERSION" ]]; then
    echo "[deploy] ERROR: missing build output: $CDN_SRC_VERSION" >&2
    echo "  Run: SP_CDN_VERSION=$SP_CDN_VERSION scripts/sp_build.sh cdn --repo '$REPO_ROOT'" >&2
    exit 1
  fi

  if [[ ! -d "$CDN_SRC_LATEST" ]]; then
    echo "[deploy] ERROR: missing latest build output: $CDN_SRC_LATEST" >&2
    echo "  Run: SP_CDN_VERSION=$SP_CDN_VERSION scripts/sp_build.sh cdn --repo '$REPO_ROOT'" >&2
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
  ASSETS_SRC="$(resolve_src assets)"
  echo "[deploy] assets -> assets.spectraportal.dev"
  echo "[deploy] repo: $REPO_ROOT"
  echo "[deploy] src:  $ASSETS_SRC"

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
  FRAMEWORK_SRC="$(resolve_src framework)"
  echo "[deploy] framework"
  echo "[deploy] repo: $REPO_ROOT"
  echo "[deploy] src:  $FRAMEWORK_SRC"

  if [[ ! -d "$FRAMEWORK_SRC" ]]; then
    echo "[deploy] ERROR: missing framework source: $FRAMEWORK_SRC" >&2
    exit 1
  fi

  remote_mkdir "$WEBROOT_FRAMEWORK"
  rsync_push "$FRAMEWORK_SRC/" "$REMOTE:$WEBROOT_FRAMEWORK/"

  echo "[deploy] framework done"
  exit 0
fi

if [[ "$TARGET" == "gate" ]]; then
  GATE_SRC="$(resolve_src gate)"
  echo "[deploy] gate -> gate.spectraportal.dev"
  echo "[deploy] repo: $REPO_ROOT"
  echo "[deploy] src:  $GATE_SRC"

  if [[ ! -d "$GATE_SRC" ]]; then
    echo "[deploy] ERROR: missing gate source: $GATE_SRC" >&2
    exit 1
  fi

  remote_mkdir "$WEBROOT_GATE"
  echo "[deploy] excluding from webroot: boot/ chat_center/ core/"
  rsync_push_filtered "$GATE_SRC/" "$REMOTE:$WEBROOT_GATE/" \
    --exclude 'boot/' \
    --exclude 'chat_center/' \
    --exclude 'core/'

  echo "[deploy] gate done"
  exit 0
fi

if [[ "$TARGET" == "gate-draft" ]]; then
  GATE_DRAFT_SRC="$(resolve_src gate/drafts)"
  echo "[deploy] gate-draft -> workspace gate drafts"
  echo "[deploy] repo: $REPO_ROOT"
  echo "[deploy] src:  $GATE_DRAFT_SRC"
  echo "[deploy] dst:  $WORKSPACE_GATE_DRAFTS"

  if [[ ! -d "$GATE_DRAFT_SRC" ]]; then
    echo "[deploy] ERROR: missing gate draft source: $GATE_DRAFT_SRC" >&2
    exit 1
  fi

  remote_mkdir "$WORKSPACE_GATE_DRAFTS"
  rsync_push "$GATE_DRAFT_SRC/" "$REMOTE:$WORKSPACE_GATE_DRAFTS/"

  echo "[deploy] gate-draft done"
  exit 0
fi

if [[ "$TARGET" == "srv" ]]; then
  BOOT_SRC="$REPO_ROOT/gate/boot"
  CHAT_CENTER_SRC="$REPO_ROOT/gate/chat_center"
  CORE_SRC="$REPO_ROOT/gate/core"

  echo "[deploy] srv -> /srv/spectraportal"
  echo "[deploy] repo: $REPO_ROOT"
  echo "[deploy] boot: $BOOT_SRC"
  echo "[deploy] chat_center: $CHAT_CENTER_SRC"
  echo "[deploy] core: $CORE_SRC"

  if [[ ! -d "$BOOT_SRC" ]]; then
    echo "[deploy] ERROR: missing boot source: $BOOT_SRC" >&2
    exit 1
  fi

  if [[ ! -d "$CHAT_CENTER_SRC" ]]; then
    echo "[deploy] ERROR: missing chat_center source: $CHAT_CENTER_SRC" >&2
    exit 1
  fi

  if [[ ! -d "$CORE_SRC" ]]; then
    echo "[deploy] ERROR: missing core source: $CORE_SRC" >&2
    exit 1
  fi

  remote_mkdir "$SRV_ROOT"
  remote_mkdir "$SRV_BOOT"
  remote_mkdir "$SRV_CHAT_CENTER"
  remote_mkdir "$SRV_CORE"

  rsync_push "$BOOT_SRC/" "$REMOTE:$SRV_BOOT/"
  rsync_push "$CHAT_CENTER_SRC/" "$REMOTE:$SRV_CHAT_CENTER/"
  rsync_push "$CORE_SRC/" "$REMOTE:$SRV_CORE/"

  echo "[deploy] srv done"
  exit 0
fi

if [[ "$TARGET" == "dev" ]]; then
  DOCS_SRC="$(resolve_src docs)"
  echo "[deploy] dev -> spectraportal.dev"
  echo "[deploy] repo: $REPO_ROOT"
  echo "[deploy] src:  $DOCS_SRC"

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
echo "[deploy] Valid targets: cdn | assets | framework | dev | gate | gate-draft | srv" >&2
echo "[deploy] Legacy alias still supported: docs -> dev" >&2
exit 1
