#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Build
#
# Current build target:
# - cdn: builds versioned + latest CDN bundles from framework
#
# Writes:
#   ./cdn/<version>/css/spectra.min.css
#   ./cdn/<version>/css/overrides.min.css
#   ./cdn/<version>/themes/theme.min.css
#   ./cdn/<version>/themes/<theme>.min.css
#   ./cdn/latest/... (mirror of the version)
#
# Notes:
# - docs/, assets/, and framework/ are source sites and do not currently
#   require a build step.
# - This script does NOT require npm/package.json.
# - Raw framework sources are not deployed to the CDN host.
# ============================================================

TARGET="${1:-cdn}"
: "${SP_CDN_VERSION:=v0.1}"

if [[ "$TARGET" != "cdn" ]]; then
  echo "[build] target: $TARGET (no build step required)"
  exit 0
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/framework"

CDN_OUT="$REPO_ROOT/cdn/$SP_CDN_VERSION"
LATEST_OUT="$REPO_ROOT/cdn/latest"

mkdir -p "$CDN_OUT/css" "$CDN_OUT/themes" "$CDN_OUT/js"

minify_css () {
  local IN="$1"
  local OUT="$2"

  if [[ -x "$REPO_ROOT/node_modules/.bin/csso" ]]; then
    "$REPO_ROOT/node_modules/.bin/csso" "$IN" --output "$OUT"
    return 0
  fi

  if command -v npx >/dev/null 2>&1; then
    if npx --yes csso "$IN" --output "$OUT" >/dev/null 2>&1; then
      npx --yes csso "$IN" --output "$OUT"
      return 0
    fi
  fi

  sed -E 's/[[:space:]]+$//' "$IN" | awk 'NF{p=1} p{print}' > "$OUT"
}

echo "[build] building version $SP_CDN_VERSION"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat \
  "$SRC/base/"*.css \
  "$SRC/tokens/"*.css \
  "$SRC/patterns/"*.css \
  "$SRC/components/"*.css \
  "$SRC/utilities/"*.css \
  "$SRC/spectra.css" 2>/dev/null > "$TMP" || true

minify_css "$TMP" "$CDN_OUT/css/spectra.min.css"

if [[ -f "$SRC/themes/themes.css" ]]; then
  minify_css "$SRC/themes/themes.css" "$CDN_OUT/themes/theme.min.css"
elif [[ -f "$SRC/themes/spectra-midnight/theme.css" ]]; then
  minify_css "$SRC/themes/spectra-midnight/theme.css" "$CDN_OUT/themes/theme.min.css"
else
  : > "$CDN_OUT/themes/theme.min.css"
fi

if [[ -d "$SRC/themes" ]]; then
  for T in "$SRC/themes/"*/theme.css; do
    [[ -f "$T" ]] || continue
    NAME="$(basename "$(dirname "$T")")"
    minify_css "$T" "$CDN_OUT/themes/$NAME.min.css"
  done
fi

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
