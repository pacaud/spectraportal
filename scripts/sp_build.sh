#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Build
#
# Goal:
#   Make builds consistent across machines.
#   Source-of-truth lives in:      framework/src/
#   Deployable artifacts live in:  framework/cdn/v0.1/
#   CDN-packaged layout lives in:  cdn/v0.1/{css,themes,js}/
#
# Usage:
#   scripts/sp_build.sh [target]
#
# Targets:
#   portal | devhub | framework | lab | cdn | gate
#
# Notes:
# - If package.json exists, we run: npm run build:all (optional)
# - We ALWAYS generate framework/cdn/v0.1 from framework/src so deploy never ships empties.
# - "*.min.css" files are not aggressively minified yet (safe + works first); can add real min later.
# ============================================================

TARGET="${1:-devhub}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "[build] target: $TARGET"
echo "[build] repo:   $REPO_ROOT"

have_cmd() { command -v "$1" >/dev/null 2>&1; }

npm_build_all() {
  if [[ -f package.json ]]; then
    echo "[build] running: npm run build:all"
    npm run build:all
  else
    echo "[build] WARN: package.json not found; skipping npm build." >&2
  fi
}

# ---- 1) Generate framework/cdn/v0.1 from framework/src ----
build_framework_cdn_from_src() {
  local SRC="$REPO_ROOT/framework/src"
  local OUT="$REPO_ROOT/framework/cdn/v0.1"

  if [[ ! -d "$SRC" ]]; then
    echo "[build] ERROR: missing source dir: $SRC" >&2
    exit 1
  fi

  mkdir -p "$OUT" "$OUT/themes" "$OUT/js"

  # Spectra base bundle (tokens -> components -> base)
  # Order matters. Keep this explicit and boring.
  local TMP_SPECTRA
  TMP_SPECTRA="$(mktemp)"
  {
    # Base
    cat "$SRC/base/reset.css"
    cat "$SRC/base/a11y.css"
    cat "$SRC/base/layout.css"
    cat "$SRC/base/utilities.css"

    # Tokens (core first, then the rest)
    cat "$SRC/tokens/core.css"
    cat "$SRC/tokens/color.css"
    cat "$SRC/tokens/type.css"
    cat "$SRC/tokens/space.css"
    cat "$SRC/tokens/radius.css"
    cat "$SRC/tokens/shadow.css"
    cat "$SRC/tokens/borders.css"
    cat "$SRC/tokens/breakpoints.css"
    cat "$SRC/tokens/motion.css"
    cat "$SRC/tokens/z.css"

    # Components (stable alphabetical-ish; explicit list prevents surprise)
    cat "$SRC/components/brand.css"
    cat "$SRC/components/button.css"
    cat "$SRC/components/badge.css"
    cat "$SRC/components/card.css"
    cat "$SRC/components/drawer.css"
    cat "$SRC/components/footer.css"
    cat "$SRC/components/form-controls.css"
    cat "$SRC/components/forms.css"
    cat "$SRC/components/header.css"
    cat "$SRC/components/hero.css"
    cat "$SRC/components/input.css"
    cat "$SRC/components/nav.css"
    cat "$SRC/components/tabs.css"
    cat "$SRC/components/toast.css"
    cat "$SRC/components/toggles.css"
    cat "$SRC/components/colors.css"
  } > "$TMP_SPECTRA"

  # "Min" (for now): strip obvious trailing whitespace + extra blank lines (safe, not destructive)
  # If sed isn't available, just keep the bundle as-is.
  if have_cmd sed; then
    sed -E 's/[[:space:]]+$//' "$TMP_SPECTRA" | sed -E '/^[[:space:]]*$/N;/\n[[:space:]]*\n$/D' > "$OUT/spectra.min.css"
  else
    cp -f "$TMP_SPECTRA" "$OUT/spectra.min.css"
  fi
  rm -f "$TMP_SPECTRA"

  # Theme bundle(s)
  # Default "theme.min.css" = themes/themes.css (theme router) if present,
  # otherwise just ship midnight theme as default.
  if [[ -f "$SRC/themes/themes.css" ]]; then
    cp -f "$SRC/themes/themes.css" "$OUT/theme.min.css"
  elif [[ -f "$SRC/themes/spectra-midnight/theme.css" ]]; then
    cp -f "$SRC/themes/spectra-midnight/theme.css" "$OUT/theme.min.css"
  else
    : > "$OUT/theme.min.css"
  fi

  # Also publish named theme(s) under framework/cdn/v0.1/themes/
  if [[ -f "$SRC/themes/spectra-midnight/theme.css" ]]; then
    cp -f "$SRC/themes/spectra-midnight/theme.css" "$OUT/themes/spectra-midnight.min.css"
  fi

  # Overrides bundle
  if [[ -f "$REPO_ROOT/overrides.css" ]]; then
    cp -f "$REPO_ROOT/overrides.css" "$OUT/overrides.min.css"
  elif [[ -f "$SRC/overrides.css" ]]; then
    cp -f "$SRC/overrides.css" "$OUT/overrides.min.css"
  else
    : > "$OUT/overrides.min.css"
  fi

  echo "[build] generated: framework/cdn/v0.1"
  ls -la "$OUT" || true
}

# ---- 2) Package a clean CDN layout at ./cdn/v0.1/{css,themes,js} ----
package_cdn_layout() {
  local SRC_BASE="$REPO_ROOT/framework/cdn/v0.1"

  local DST_BASE="$REPO_ROOT/cdn/v0.1"
  local DST_CSS="$DST_BASE/css"
  local DST_THEMES="$DST_BASE/themes"
  local DST_JS="$DST_BASE/js"

  mkdir -p "$DST_CSS" "$DST_THEMES" "$DST_JS"

  echo "[build] packaging CDN layout:"
  echo "        from: $SRC_BASE"
  echo "        to:   $DST_BASE"

  # Core CSS
  cp -f "$SRC_BASE/spectra.min.css" "$DST_CSS/spectra.min.css"

  # Overrides (optional but handy)
  if [[ -f "$SRC_BASE/overrides.min.css" ]]; then
    cp -f "$SRC_BASE/overrides.min.css" "$DST_CSS/overrides.min.css"
  fi

  # Themes
  if [[ -d "$SRC_BASE/themes" ]]; then
    # copy any named themes
    if have_cmd rsync; then
      rsync -a --delete "$SRC_BASE/themes/" "$DST_THEMES/"
    else
      rm -rf "$DST_THEMES" && mkdir -p "$DST_THEMES"
      cp -R "$SRC_BASE/themes/." "$DST_THEMES/"
    fi
  fi

  # Default theme bundle at root (if present)
  if [[ -f "$SRC_BASE/theme.min.css" ]]; then
    cp -f "$SRC_BASE/theme.min.css" "$DST_THEMES/theme.min.css"
  fi

  # JS (future)
  if [[ -d "$SRC_BASE/js" ]]; then
    if have_cmd rsync; then
      rsync -a --delete "$SRC_BASE/js/" "$DST_JS/"
    else
      rm -rf "$DST_JS" && mkdir -p "$DST_JS"
      cp -R "$SRC_BASE/js/." "$DST_JS/"
    fi
  fi

  echo "[build] CDN outputs:"
  ls -la "$DST_BASE" || true
  ls -la "$DST_CSS" || true
  ls -la "$DST_THEMES" || true
  ls -la "$DST_JS" || true
}

case "$TARGET" in
  portal|lab|gate)
    echo "[build] skipping (no build required for target: $TARGET)"
    ;;

  devhub|framework)
    npm_build_all
    build_framework_cdn_from_src
    ;;

  cdn)
    npm_build_all
    build_framework_cdn_from_src
    package_cdn_layout
    ;;

  *)
    echo "[build] ERROR: unknown target: $TARGET" >&2
    echo "[build] Valid targets: portal | devhub | framework | lab | cdn | gate" >&2
    exit 1
    ;;
esac
