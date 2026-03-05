#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   scripts/sp_build.sh [target]
#
# Targets:
#   portal | devhub | framework | lab | cdn
#
# Notes:
# - If package.json exists, devhub/framework/cdn will run npm build.
# - CDN packaging step creates a clean repo-local layout at:
#     ./cdn/v0.1/css/
#     ./cdn/v0.1/themes/
#     ./cdn/v0.1/js/

TARGET="${1:-devhub}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "[build] target: $TARGET"
echo "[build] repo:   $REPO_ROOT"

# ---- helpers ----
have_cmd() { command -v "$1" >/dev/null 2>&1; }

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp -f "$src" "$dst"
    return 0
  fi
  return 1
}

sync_dir_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    if have_cmd rsync; then
      rsync -a --delete "${src%/}/" "${dst%/}/"
    else
      rm -rf "$dst"
      mkdir -p "$dst"
      cp -R "${src%/}/." "$dst/"
    fi
    return 0
  fi
  return 1
}

npm_build_all() {
  if [[ -f package.json ]]; then
    echo "[build] running: npm run build:all"
    npm run build:all
  else
    echo "[build] WARN: package.json not found; skipping npm build." >&2
  fi
}

# ---- CDN packaging ----
package_cdn_layout() {
  # Source defaults (what you currently generate)
  local SRC_BASE="$REPO_ROOT/framework/cdn/v0.1"

  # Destination layout (clean CDN structure inside repo)
  local DST_BASE="$REPO_ROOT/cdn/v0.1"
  local DST_CSS="$DST_BASE/css"
  local DST_THEMES="$DST_BASE/themes"
  local DST_JS="$DST_BASE/js"

  mkdir -p "$DST_CSS" "$DST_THEMES" "$DST_JS"

  if [[ ! -d "$SRC_BASE" ]]; then
    echo "[build] WARN: expected build output missing: $SRC_BASE" >&2
    echo "[build]       (Either run your build first, or adjust SRC_BASE in sp_build.sh)" >&2
    return 0
  fi

  echo "[build] packaging CDN layout:"
  echo "        from: $SRC_BASE"
  echo "        to:   $DST_BASE"

  # 1) Core CSS (spectra)
  local copied_any="0"
  if copy_if_exists "$SRC_BASE/spectra.min.css" "$DST_CSS/spectra.min.css"; then copied_any="1"; fi
  copy_if_exists "$SRC_BASE/spectra.min.css.map" "$DST_CSS/spectra.min.css.map" || true

  # 2) Theme CSS
  # Prefer a themes/ folder if you have it; else grab common theme-ish files
  if ! sync_dir_if_exists "$SRC_BASE/themes" "$DST_THEMES"; then
    shopt -s nullglob
    for f in "$SRC_BASE"/theme*.min.css "$SRC_BASE"/*theme*.min.css; do
      cp -f "$f" "$DST_THEMES/$(basename "$f")"
      copied_any="1"
    done
    shopt -u nullglob
  else
    copied_any="1"
  fi

  # 3) JS (optional)
  if sync_dir_if_exists "$SRC_BASE/js" "$DST_JS"; then
    copied_any="1"
  else
    # If you have any minified JS flat in SRC_BASE, copy it.
    shopt -s nullglob
    for f in "$SRC_BASE"/*.min.js "$SRC_BASE"/*.js; do
      cp -f "$f" "$DST_JS/$(basename "$f")"
      copied_any="1"
    done
    shopt -u nullglob
  fi

  if [[ "$copied_any" == "0" ]]; then
    echo "[build] WARN: nothing packaged into ./cdn/v0.1 (no matching files found)." >&2
  fi

  echo "[build] CDN outputs:"
  ls -la "$DST_BASE" || true
  ls -la "$DST_CSS" || true
  ls -la "$DST_THEMES" || true
  ls -la "$DST_JS" || true
}

case "$TARGET" in
  devhub|framework)
    npm_build_all
    if [[ -d framework/cdn/v0.1 ]]; then
      echo "[build] outputs:"
      ls -la framework/cdn/v0.1
    else
      echo "[build] WARN: expected output missing: framework/cdn/v0.1" >&2
    fi
    ;;
  cdn)
    # Build first (if possible), then package into ./cdn/v0.1/...
    npm_build_all
    package_cdn_layout
    ;;
  portal|lab)
    echo "[build] skipping (no npm build required for target: $TARGET)"
    ;;
  *)
    echo "[build] ERROR: unknown target: $TARGET" >&2
    echo "[build] Valid targets: portal | devhub | framework | lab | cdn" >&2
    exit 1
    ;;
esac