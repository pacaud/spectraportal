#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Publish: deploy different "sites" (targets)
#
# Targets:
#   portal    -> spectraportal.com           (front door)
#   devhub    -> spectraportal.dev           (docs + demos hub)
#   framework -> framework.spectraportal.dev (pure framework surface)
#   lab       -> spectraportal.online        (experiments)
#
# Usage:
#   scripts/sp_deploy.sh [target]
#
# Config:
#   scripts/sp_deploy.env may define:
#     REMOTE="root@server"
#     # Optional overrides per target:
#     WEBROOT_PORTAL="/var/www/spectraportal.com"
#     WEBROOT_DEVHUB="/var/www/spectraportal.dev"
#     WEBROOT_FRAMEWORK="/var/www/framework.spectraportal.dev"
#     WEBROOT_LAB="/var/www/spectraportal.online"
#     # Back-compat (if set, overrides all targets):
#     WEBROOT="/var/www/spectraportal.dev"
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
  # Back-compat: explicit WEBROOT overrides target mapping.
  RESOLVED_WEBROOT="$WEBROOT"
else
  case "$TARGET" in
    portal)
      RESOLVED_WEBROOT="${WEBROOT_PORTAL:-/var/www/spectraportal.com}"
      ;;
    devhub)
      RESOLVED_WEBROOT="${WEBROOT_DEVHUB:-/var/www/spectraportal.dev}"
      ;;
    framework)
      RESOLVED_WEBROOT="${WEBROOT_FRAMEWORK:-/var/www/framework.spectraportal.dev}"
      ;;
    lab)
      RESOLVED_WEBROOT="${WEBROOT_LAB:-/var/www/spectraportal.online}"
      ;;
    *)
      echo "[deploy] ERROR: unknown target: $TARGET" >&2
      echo "[deploy] Valid targets: portal | devhub | framework | lab" >&2
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

# ---- Determine source root for "site root files" ----
# If you later create per-target folders (portal/, devhub/, lab/, framework_site/), this will just work.
SITE_SRC="$REPO_ROOT"
case "$TARGET" in
  portal)     [[ -d "$REPO_ROOT/portal" ]] && SITE_SRC="$REPO_ROOT/portal" ;;
  devhub)     [[ -d "$REPO_ROOT/devhub" ]] && SITE_SRC="$REPO_ROOT/devhub" ;;
  lab)        [[ -d "$REPO_ROOT/lab" ]] && SITE_SRC="$REPO_ROOT/lab" ;;
  framework)  [[ -d "$REPO_ROOT/framework_site" ]] && SITE_SRC="$REPO_ROOT/framework_site" ;;
esac

# ---- Ensure destination folders exist ----
# Everyone gets /assets, but only some targets get framework subtrees.
if [[ "$TARGET" == "devhub" ]]; then
  ssh "$REMOTE" "mkdir -p     '$WEBROOT/assets/brand'     '$WEBROOT/framework/cdn/v0.1'     '$WEBROOT/framework/demos'     '$WEBROOT/framework/docs'   "
elif [[ "$TARGET" == "framework" ]]; then
  ssh "$REMOTE" "mkdir -p     '$WEBROOT/assets/brand'     '$WEBROOT/cdn/v0.1'     '$WEBROOT/demos'     '$WEBROOT/docs'   "
else
  ssh "$REMOTE" "mkdir -p '$WEBROOT/assets/brand'"
fi

# ---- Assets (shared) ----
# We sync repo-level /assets by default.
rsync_dir "$REPO_ROOT/assets" "$REMOTE:$WEBROOT/assets"

# ---- Root files (per-site) ----
ROOT_FILES=(index.html robots.txt favicon.ico site.webmanifest)
for f in "${ROOT_FILES[@]}"; do
  rsync_file_if_exists "$SITE_SRC/$f" "$REMOTE:$WEBROOT/$f"
done

# ---- Target-specific payloads ----
case "$TARGET" in
  portal)
    # Front door. Keep it simple; add portal-only folders here later if you want.
    ;;
  lab)
    # Experiments. Add lab-only bundles here later.
    ;;
  devhub)
    # Dev hub hosts framework under /framework/...
    rsync_dir "$REPO_ROOT/framework/cdn/v0.1" "$REMOTE:$WEBROOT/framework/cdn/v0.1"
    rsync_dir "$REPO_ROOT/framework/demos" "$REMOTE:$WEBROOT/framework/demos"
    rsync_dir "$REPO_ROOT/framework/docs"  "$REMOTE:$WEBROOT/framework/docs"
    ;;
  framework)
    # Pure framework domain: no extra /framework prefix.
    rsync_dir "$REPO_ROOT/framework/cdn/v0.1" "$REMOTE:$WEBROOT/cdn/v0.1"
    rsync_dir "$REPO_ROOT/framework/demos"   "$REMOTE:$WEBROOT/demos"
    rsync_dir "$REPO_ROOT/framework/docs"    "$REMOTE:$WEBROOT/docs"

    # Optional: if you keep a framework landing page in framework/index.html
    # and you DIDN'T create a separate framework_site/ folder, copy it to root.
    if [[ -f "$REPO_ROOT/framework/index.html" && ! -f "$SITE_SRC/index.html" ]]; then
      rsync_file_if_exists "$REPO_ROOT/framework/index.html" "$REMOTE:$WEBROOT/index.html"
    fi
    ;;
esac

echo "[deploy] done."
