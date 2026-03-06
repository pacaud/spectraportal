#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Build (CDN-only)
#
# Builds versioned + latest CDN bundles from framework/src and writes:
#   ./cdn/<version>/css/spectra.min.css
#   ./cdn/<version>/css/overrides.min.css
#   ./cdn/<version>/themes/theme.min.css
#   ./cdn/<version>/themes/<theme>.min.css
#   ./cdn/latest/... (mirror of the version)
#
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_build.sh cdn
#
# Notes:
# - Intentionally does NOT require npm/package.json.
# - Servers should NOT receive raw sources (framework/src).
# ============================================================

TARGET="${1:-cdn}"
: "${SP_CDN_VERSION:=v0.1}"

if [[ "$TARGET" != "cdn" ]]; then
  echo "[build] target: $TARGET (no-op; only 'cdn' produces build artifacts)"
  exit 0
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/framework/src"

CDN_OUT="$REPO_ROOT/cdn/$SP_CDN_VERSION"
LATEST_OUT="$REPO_ROOT/cdn/latest"

mkdir -p "$CDN_OUT/css" "$CDN_OUT/themes" "$CDN_OUT/js"

minify_css () {
  local IN="$1"
  local OUT="$2"

  # Prefer project-local install (deterministic)
  if [[ -x "$REPO_ROOT/node_modules/.bin/csso" ]]; then
    "$REPO_ROOT/node_modules/.bin/csso" "$IN" --output "$OUT"
    return 0
  fi

  # Next best: npx csso (if available)
  if command -v npx >/dev/null 2>&1; then
    if npx --yes csso "$IN" --output "$OUT" >/dev/null 2>&1; then
      npx --yes csso "$IN" --output "$OUT"
      return 0
    fi
  fi

  # Fallback: "safe-min" (portable, stable)
  sed -E 's/[[:space:]]+$//' "$IN" | awk 'NF{p=1} p{print}' > "$OUT"
}

echo "[build] building version $SP_CDN_VERSION"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# Base bundle: base -> tokens -> components -> spectra.css
cat "$SRC/base/"*.css "$SRC/tokens/"*.css "$SRC/components/"*.css "$SRC/spectra.css" 2>/dev/null > "$TMP" || true
minify_css "$TMP" "$CDN_OUT/css/spectra.min.css"

# Default theme bundle:
# - Prefer themes/themes.css (aggregator)
# - Else fallback to spectra-midnight/theme.css
if [[ -f "$SRC/themes/themes.css" ]]; then
  minify_css "$SRC/themes/themes.css" "$CDN_OUT/themes/theme.min.css"
elif [[ -f "$SRC/themes/spectra-midnight/theme.css" ]]; then
  minify_css "$SRC/themes/spectra-midnight/theme.css" "$CDN_OUT/themes/theme.min.css"
else
  : > "$CDN_OUT/themes/theme.min.css"
fi

# Named themes: themes/<name>.min.css
if [[ -d "$SRC/themes" ]]; then
  for T in "$SRC/themes/"*/theme.css; do
    [[ -f "$T" ]] || continue
    NAME="$(basename "$(dirname "$T")")"
    minify_css "$T" "$CDN_OUT/themes/$NAME.min.css"
  done
fi

# Overrides
if [[ -f "$SRC/overrides.css" ]]; then
  minify_css "$SRC/overrides.css" "$CDN_OUT/css/overrides.min.css"
else
  : > "$CDN_OUT/css/overrides.min.css"
fi

echo "[build] updating latest"

rm -rf "$LATEST_OUT"
mkdir -p "$LATEST_OUT"
cp -r "$CDN_OUT/"* "$LATEST_OUT/"

echo "[build] done"
