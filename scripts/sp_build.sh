#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-cdn}"
: "${SP_CDN_VERSION:=v0.1}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/framework/src"
CDN_OUT="$REPO_ROOT/cdn/$SP_CDN_VERSION"
LATEST_OUT="$REPO_ROOT/cdn/latest"

mkdir -p "$CDN_OUT/css" "$CDN_OUT/themes" "$CDN_OUT/js"

minify_css () {
  local IN="$1"
  local OUT="$2"

  if [[ -x "$REPO_ROOT/node_modules/.bin/csso" ]]; then
    "$REPO_ROOT/node_modules/.bin/csso" "$IN" --output "$OUT"
    return
  fi

  if command -v npx >/dev/null 2>&1; then
    if npx --yes csso "$IN" --output "$OUT" >/dev/null 2>&1; then
      npx --yes csso "$IN" --output "$OUT"
      return
    fi
  fi

  sed -E 's/[[:space:]]+$//' "$IN" | sed -E '/^[[:space:]]*$/N;/\n[[:space:]]*\n$/D' > "$OUT"
}

echo "[build] building version $SP_CDN_VERSION"

TMP="$(mktemp)"

cat "$SRC/base/"*.css "$SRC/tokens/"*.css "$SRC/components/"*.css > "$TMP"

minify_css "$TMP" "$CDN_OUT/css/spectra.min.css"
rm "$TMP"

if [[ -f "$SRC/themes/themes.css" ]]; then
  minify_css "$SRC/themes/themes.css" "$CDN_OUT/themes/theme.min.css"
fi

if [[ -d "$SRC/themes" ]]; then
  for T in "$SRC/themes/"*/theme.css; do
    NAME="$(basename "$(dirname "$T")")"
    minify_css "$T" "$CDN_OUT/themes/$NAME.min.css"
  done
fi

if [[ -f "$SRC/overrides.css" ]]; then
  minify_css "$SRC/overrides.css" "$CDN_OUT/css/overrides.min.css"
fi

echo "[build] updating latest"

rm -rf "$LATEST_OUT"
mkdir -p "$LATEST_OUT"
cp -r "$CDN_OUT/"* "$LATEST_OUT/"

echo "[build] done"
