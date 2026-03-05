#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Deploy (target-aware)
#
# Targets:
#   portal    -> spectraportal.com            (front door)
#   devhub    -> spectraportal.dev            (dev hub / staging)
#   framework -> framework.spectraportal.dev  (framework site)
#   cdn       -> cdn.spectraportal.dev        (versioned assets)
#   lab       -> spectraportal.online         (experiments)
#   gate      -> gate.spectraportal.dev       (pipe / boot / manifests)  [optional]
#
# Usage:
#   scripts/sp_deploy.sh [target]
#
# Config (scripts/sp_deploy.env):
#   REMOTE="root@100.121.30.60"
#   # Optional per-target webroots:
#   WEBROOT_PORTAL="/var/www/spectraportal.com"
#   WEBROOT_DEVHUB="/var/www/spectraportal.dev"
#   WEBROOT_FRAMEWORK="/var/www/framework.spectraportal.dev"
#   WEBROOT_CDN="/var/www/cdn.spectraportal.dev"
#   WEBROOT_LAB="/var/www/spectraportal.online"
#   WEBROOT_GATE="/var/www/gate.spectraportal.dev"
#   # Back-compat override (forces ALL targets):
#   WEBROOT="/var/www/spectraportal.dev"
# ============================================================

TARGET="${1:-devhub}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

ENV_FILE="$REPO_ROOT/scripts/sp_deploy.env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

: "${REMOTE:?Set REMOTE in scripts/sp_deploy.env (e.g. root@server)}"

# ---- Resolve WEBROOT (target-aware) ----
if [[ -n "${WEBROOT:-}" ]]; then
  RESOLVED_WEBROOT="$WEBROOT"
else
  case "$TARGET" in
    portal)    RESOLVED_WEBROOT="${WEBROOT_PORTAL:-/var/www/spectraportal.com}" ;;
    devhub)    RESOLVED_WEBROOT="${WEBROOT_DEVHUB:-/var/www/spectraportal.dev}" ;;
    framework) RESOLVED_WEBROOT="${WEBROOT_FRAMEWORK:-/var/www/framework.spectraportal.dev}" ;;
    cdn)       RESOLVED_WEBROOT="${WEBROOT_CDN:-/var/www/cdn.spectraportal.dev}" ;;
    lab)       RESOLVED_WEBROOT="${WEBROOT_LAB:-/var/www/spectraportal.online}" ;;
    gate)      RESOLVED_WEBROOT="${WEBROOT_GATE:-/var/www/gate.spectraportal.dev}" ;;
    *)
      echo "[deploy] ERROR: unknown target: $TARGET" >&2
      echo "[deploy] Valid targets: portal | devhub | framework | cdn | lab | gate" >&2
      exit 1
      ;;
  esac
fi

WEBROOT="$RESOLVED_WEBROOT"

echo "[deploy] target:  $TARGET"
echo "[deploy] remote:  $REMOTE"
echo "[deploy] webroot: $WEBROOT"

# ---- Helpers ----
rsync_dir() {
  local src="$1"
  local dst="$2"
  if [[ -d "$src" ]]; then
    rsync -av --delete "$src/" "$dst/"
  fi
}

rsync_file_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    rsync -av "$src" "$dst"
  fi
}

# ---- Determine per-target SITE_SRC for root files ----
SITE_SRC="$REPO_ROOT"
case "$TARGET" in
  portal)     [[ -d "$REPO_ROOT/portal" ]] && SITE_SRC="$REPO_ROOT/portal" ;;
  devhub)     [[ -d "$REPO_ROOT/devhub" ]] && SITE_SRC="$REPO_ROOT/devhub" ;;
  lab)        [[ -d "$REPO_ROOT/lab" ]] && SITE_SRC="$REPO_ROOT/lab" ;;
  framework)  [[ -d "$REPO_ROOT/framework_site" ]] && SITE_SRC="$REPO_ROOT/framework_site" ;;
  cdn)        [[ -d "$REPO_ROOT/cdn_site" ]] && SITE_SRC="$REPO_ROOT/cdn_site" ;;
  gate)       [[ -d "$REPO_ROOT/gate" ]] && SITE_SRC="$REPO_ROOT/gate" ;;
esac

# ---- Ensure destination folders exist ----
case "$TARGET" in
  devhub)
    ssh "$REMOTE" "mkdir -p \
      '$WEBROOT/assets/brand' \
      '$WEBROOT/framework/cdn/v0.1' \
      '$WEBROOT/framework/demos' \
      '$WEBROOT/framework/docs' \
    "
    ;;
  framework)
    ssh "$REMOTE" "mkdir -p \
      '$WEBROOT/assets/brand' \
      '$WEBROOT/demos' \
      '$WEBROOT/docs' \
    "
    ;;
  cdn)
    ssh "$REMOTE" "mkdir -p \
      '$WEBROOT/v0.1/css' \
      '$WEBROOT/v0.1/themes' \
      '$WEBROOT/v0.1/js' \
    "
    ;;
  gate)
    ssh "$REMOTE" "mkdir -p '$WEBROOT'" 
    ;;
  *)
    ssh "$REMOTE" "mkdir -p '$WEBROOT/assets/brand'" 
    ;;
esac

# ---- Assets (shared) ----
# Only sync brand assets to sites that need them.
if [[ "$TARGET" != "cdn" && "$TARGET" != "gate" ]]; then
  rsync_dir "$REPO_ROOT/assets" "$REMOTE:$WEBROOT/assets"
fi

# ---- Root files (per-site) ----
ROOT_FILES=(index.html robots.txt favicon.ico site.webmanifest)
for f in "${ROOT_FILES[@]}"; do
  rsync_file_if_exists "$SITE_SRC/$f" "$REMOTE:$WEBROOT/$f"
done

# ---- Target-specific payloads ----
case "$TARGET" in
  portal)
    # Front door. Keep it simple for now.
    ;;

  lab)
    # Experiments. Add lab-only bundles later.
    ;;

  devhub)
    # Dev hub hosts framework under /framework/...
    rsync_dir "$REPO_ROOT/framework/cdn/v0.1" "$REMOTE:$WEBROOT/framework/cdn/v0.1"
    rsync_dir "$REPO_ROOT/framework/demos"   "$REMOTE:$WEBROOT/framework/demos"
    rsync_dir "$REPO_ROOT/framework/docs"    "$REMOTE:$WEBROOT/framework/docs"
    ;;

  framework)
    # Pure framework domain: no extra /framework prefix. (No /cdn mirror here; CDN lives on cdn.spectraportal.dev)
    rsync_dir "$REPO_ROOT/framework/demos"   "$REMOTE:$WEBROOT/demos"
    rsync_dir "$REPO_ROOT/framework/docs"    "$REMOTE:$WEBROOT/docs"

    # If you keep a framework landing page in framework/index.html, use it as fallback.
    if [[ -f "$REPO_ROOT/framework/index.html" && ! -f "$SITE_SRC/index.html" ]]; then
      rsync_file_if_exists "$REPO_ROOT/framework/index.html" "$REMOTE:$WEBROOT/index.html"
    fi
    ;;

  cdn)
    # CDN is versioned artifacts ONLY.
    # Expect ./cdn/v0.1/{css,themes,js} from sp_build.sh (target=cdn).
    rsync_dir "$REPO_ROOT/cdn/v0.1/css"    "$REMOTE:$WEBROOT/v0.1/css"
    rsync_dir "$REPO_ROOT/cdn/v0.1/themes" "$REMOTE:$WEBROOT/v0.1/themes"
    rsync_dir "$REPO_ROOT/cdn/v0.1/js"     "$REMOTE:$WEBROOT/v0.1/js"
    ;;

  gate)
    # Gate is optional here. If you build gate output elsewhere (pkw gate script),
    # point it at repo-level ./gate/dist or similar.
    if [[ -d "$REPO_ROOT/dist/gate" ]]; then
      rsync_dir "$REPO_ROOT/dist/gate" "$REMOTE:$WEBROOT"
    elif [[ -d "$REPO_ROOT/gate" ]]; then
      rsync_dir "$REPO_ROOT/gate" "$REMOTE:$WEBROOT"
    else
      echo "[deploy] NOTE: no gate folder found to deploy (expected dist/gate or gate/)." >&2
    fi
    ;;

  *)
    echo "[deploy] ERROR: unknown target: $TARGET" >&2
    exit 1
    ;;
esac

echo "[deploy] done."
