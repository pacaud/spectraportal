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
# - dev/ (from ./docs), assets/, and framework/ are source sites and do not
#   currently require a build step.
# - The target name is `dev`, but it deploys the local ./docs source tree.
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

append_css_files() {
  local OUT_TMP="$1"
  shift

  local wrote=0
  local FILE
  for FILE in "$@"; do
    [[ -f "$FILE" ]] || continue
    cat "$FILE" >> "$OUT_TMP"
    printf '\n' >> "$OUT_TMP"
    wrote=1
  done

  return $wrote
}

collect_theme_bits() {
  local DIR="$1"
  if [[ -d "$DIR/theme-bits" ]]; then
    find "$DIR/theme-bits" -maxdepth 1 -type f -name '*.css' | sort
  fi
}

build_theme_bundle() {
  local OUT="$1"
  shift

  local THEME_TMP
  THEME_TMP="$(mktemp)"

  if append_css_files "$THEME_TMP" "$@"; then
    minify_css "$THEME_TMP" "$OUT"
    rm -f "$THEME_TMP"
    return 0
  fi

  rm -f "$THEME_TMP"
  return 1
}

DEFAULT_THEME_SOURCES=()

if [[ -f "$SRC/themes/themes.css" ]]; then
  DEFAULT_THEME_SOURCES+=("$SRC/themes/themes.css")
  while IFS= read -r FILE; do
    DEFAULT_THEME_SOURCES+=("$FILE")
  done < <(collect_theme_bits "$SRC/themes")
elif [[ -f "$SRC/themes/spectra-midnight/theme.css" ]]; then
  DEFAULT_THEME_SOURCES+=("$SRC/themes/spectra-midnight/theme.css")
  while IFS= read -r FILE; do
    DEFAULT_THEME_SOURCES+=("$FILE")
  done < <(collect_theme_bits "$SRC/themes/spectra-midnight")
elif [[ -f "$SRC/theme.css" ]]; then
  DEFAULT_THEME_SOURCES+=("$SRC/theme.css")
  while IFS= read -r FILE; do
    DEFAULT_THEME_SOURCES+=("$FILE")
  done < <(collect_theme_bits "$SRC")
else
  echo "[build] ERROR: no default theme source found" >&2
  echo "[build] Looked for:" >&2
  echo "  - $SRC/themes/themes.css" >&2
  echo "  - $SRC/themes/spectra-midnight/theme.css" >&2
  echo "  - $SRC/theme.css" >&2
  exit 1
fi

build_theme_bundle "$CDN_OUT/themes/theme.min.css" "${DEFAULT_THEME_SOURCES[@]}"

if [[ -d "$SRC/themes" ]]; then
  shopt -s nullglob
  for T in "$SRC/themes/"*/theme.css; do
    [[ -f "$T" ]] || continue
    NAME="$(basename "$(dirname "$T")")"

    THEME_SOURCES=("$T")
    while IFS= read -r FILE; do
      THEME_SOURCES+=("$FILE")
    done < <(collect_theme_bits "$(dirname "$T")")

    build_theme_bundle "$CDN_OUT/themes/$NAME.min.css" "${THEME_SOURCES[@]}"
  done
  shopt -u nullglob
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
