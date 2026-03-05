#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Build (selectors + presets)
#
# Goal:
#   Make builds consistent across machines, but configurable.
#
# Source-of-truth:
#   framework/src/
#
# Generated artifacts:
#   framework/cdn/<version>/
#
# CDN-packaged layout:
#   cdn/<version>/{css,themes,js}/
#
# Usage:
#   scripts/sp_build.sh [target]
#
# Targets:
#   portal | devhub | framework | lab | cdn | gate
#
# Selectors (env vars):
#   SP_PRESET=full|minimal|tokens-only
#   SP_CDN_VERSION=v0.1
#
#   SP_INCLUDE_BASE=1|0
#   SP_INCLUDE_TOKENS=1|0
#   SP_INCLUDE_COMPONENTS=1|0
#
#   SP_BASE_FILES="reset a11y layout utilities"
#   SP_TOKEN_FILES="core color type space radius shadow borders breakpoints motion z"
#   SP_COMPONENT_FILES="brand button badge card drawer footer form-controls forms header hero input nav tabs toast toggles colors"
#
#   SP_THEME_DEFAULT=themes.css|spectra-midnight/theme.css|<path>
#   SP_THEME_NAMED="spectra-midnight"   # space-separated theme folder names under src/themes/
#
#   SP_OVERRIDES_FILE="overrides.css"   # repo root path (fallback: framework/src/overrides.css)
#
# Notes:
# - Minification prefers csso-cli when available; falls back to safe-min if not.
# - You can later swap in real minification (csso/clean-css) without changing selectors.
# ============================================================

TARGET="${1:-devhub}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

have_cmd() { command -v "$1" >/dev/null 2>&1; }

echo "[build] target: $TARGET"
echo "[build] repo:   $REPO_ROOT"

# ---------------------------
# Defaults (selectors)
# ---------------------------
: "${SP_PRESET:=full}"
: "${SP_CDN_VERSION:=v0.1}"

# Include flags (1=yes, 0=no)
: "${SP_INCLUDE_BASE:=1}"
: "${SP_INCLUDE_TOKENS:=1}"
: "${SP_INCLUDE_COMPONENTS:=1}"

# File lists (space-separated keys)
: "${SP_BASE_FILES:=reset a11y layout utilities}"
: "${SP_TOKEN_FILES:=core color type space radius shadow borders breakpoints motion z}"
: "${SP_COMPONENT_FILES:=brand button badge card drawer footer form-controls forms header hero input nav tabs toast toggles colors}"

# Theme selection
# Default theme bundle: if themes/themes.css exists we default to that; otherwise midnight theme.
: "${SP_THEME_DEFAULT:=AUTO}"
: "${SP_THEME_NAMED:=spectra-midnight}"

# Overrides selection
: "${SP_OVERRIDES_FILE:=overrides.css}"

# Apply presets (these just tweak the selectors above)
apply_preset() {
  case "$SP_PRESET" in
    full)
      SP_INCLUDE_BASE=1
      SP_INCLUDE_TOKENS=1
      SP_INCLUDE_COMPONENTS=1
      ;;
    minimal)
      # good for super-light demos: base + tokens + only core UI bits
      SP_INCLUDE_BASE=1
      SP_INCLUDE_TOKENS=1
      SP_INCLUDE_COMPONENTS=1
      SP_COMPONENT_FILES="brand button input nav"
      ;;
    tokens-only)
      SP_INCLUDE_BASE=0
      SP_INCLUDE_TOKENS=1
      SP_INCLUDE_COMPONENTS=0
      ;;
    *)
      echo "[build] ERROR: unknown SP_PRESET: $SP_PRESET" >&2
      echo "[build] Valid: full | minimal | tokens-only" >&2
      exit 1
      ;;
  esac
}

apply_preset

npm_build_all() {
  if [[ -f package.json ]]; then
    echo "[build] running: npm run build:all"
    npm run build:all
  else
    echo "[build] WARN: package.json not found; skipping npm build." >&2
  fi
}

# Minify CSS:
# - Prefer real minification via csso-cli if available
# - Fallback to the prior "safe min" (trim trailing spaces + collapse blank lines)
minify_css() {
  local in="$1"
  local out="$2"

  # Prefer project-local install (deterministic)
  if [[ -x "$REPO_ROOT/node_modules/.bin/csso" ]]; then
    "$REPO_ROOT/node_modules/.bin/csso" "$in" --output "$out"
    return 0
  fi

  # Next: npx (works if node + csso-cli are available)
  if have_cmd npx; then
    if npx --yes csso "$in" --output "$out" >/dev/null 2>&1; then
      npx --yes csso "$in" --output "$out"
      return 0
    fi
  fi

  # Fallback: safe-min
  if have_cmd sed; then
    sed -E 's/[[:space:]]+$//' "$in" | sed -E '/^[[:space:]]*$/N;/\n[[:space:]]*\n$/D' > "$out"
  else
    cp -f "$in" "$out"
  fi
}

# ---- 1) Generate framework/cdn/<version> from framework/src ----
build_framework_cdn_from_src() {
  local SRC="$REPO_ROOT/framework/src"
  local OUT="$REPO_ROOT/framework/cdn/$SP_CDN_VERSION"

  if [[ ! -d "$SRC" ]]; then
    echo "[build] ERROR: missing source dir: $SRC" >&2
    exit 1
  fi

  mkdir -p "$OUT" "$OUT/themes" "$OUT/js"

  local TMP_SPECTRA
  TMP_SPECTRA="$(mktemp)"

  # Helper to append a file if present, else fail (keeps builds strict)
  append_required() {
    local f="$1"
    if [[ ! -f "$f" ]]; then
      echo "[build] ERROR: missing required file: $f" >&2
      exit 1
    fi
    cat "$f"
    echo ""  # newline between chunks
  }

  echo "[build] selectors:"
  echo "        preset=$SP_PRESET version=$SP_CDN_VERSION"
  echo "        base=$SP_INCLUDE_BASE tokens=$SP_INCLUDE_TOKENS components=$SP_INCLUDE_COMPONENTS"
  echo "        base_files=($SP_BASE_FILES)"
  echo "        token_files=($SP_TOKEN_FILES)"
  echo "        component_files=($SP_COMPONENT_FILES)"
  echo "        theme_default=$SP_THEME_DEFAULT theme_named=($SP_THEME_NAMED)"
  echo "        overrides_file=$SP_OVERRIDES_FILE"

  {
    # Base
    if [[ "$SP_INCLUDE_BASE" == "1" ]]; then
      for k in $SP_BASE_FILES; do
        append_required "$SRC/base/$k.css"
      done
    fi

    # Tokens
    if [[ "$SP_INCLUDE_TOKENS" == "1" ]]; then
      for k in $SP_TOKEN_FILES; do
        append_required "$SRC/tokens/$k.css"
      done
    fi

    # Components
    if [[ "$SP_INCLUDE_COMPONENTS" == "1" ]]; then
      for k in $SP_COMPONENT_FILES; do
        append_required "$SRC/components/$k.css"
      done
    fi
  } > "$TMP_SPECTRA"

  minify_css "$TMP_SPECTRA" "$OUT/spectra.min.css"
  rm -f "$TMP_SPECTRA"

  # ---------------------------
  # Theme bundle(s)
  # ---------------------------
  # AUTO behavior: prefer themes/themes.css, else midnight theme.
if [[ "$SP_THEME_DEFAULT" == "AUTO" ]]; then
  if [[ -f "$SRC/themes/themes.css" ]]; then
    minify_css "$SRC/themes/themes.css" "$OUT/theme.min.css"
  elif [[ -f "$SRC/themes/spectra-midnight/theme.css" ]]; then
    minify_css "$SRC/themes/spectra-midnight/theme.css" "$OUT/theme.min.css"
  else
    : > "$OUT/theme.min.css"
  fi
else
  # allow explicit file (relative to SRC/themes or absolute path)
  if [[ -f "$SRC/themes/$SP_THEME_DEFAULT" ]]; then
    minify_css "$SRC/themes/$SP_THEME_DEFAULT" "$OUT/theme.min.css"
  elif [[ -f "$SP_THEME_DEFAULT" ]]; then
    minify_css "$SP_THEME_DEFAULT" "$OUT/theme.min.css"
  else
    echo "[build] ERROR: SP_THEME_DEFAULT not found: $SP_THEME_DEFAULT" >&2
    exit 1
  fi
fi
  else
    # allow explicit file (relative to SRC/themes or absolute path)
    if [[ -f "$SRC/themes/$SP_THEME_DEFAULT" ]]; then
      cp -f "$SRC/themes/$SP_THEME_DEFAULT" "$OUT/theme.min.css"
    elif [[ -f "$SP_THEME_DEFAULT" ]]; then
      cp -f "$SP_THEME_DEFAULT" "$OUT/theme.min.css"
    else
      echo "[build] ERROR: SP_THEME_DEFAULT not found: $SP_THEME_DEFAULT" >&2
      exit 1
    fi
  fi

  # Named theme(s) under framework/cdn/<version>/themes/
  for t in $SP_THEME_NAMED; do
    if [[ -f "$SRC/themes/$t/theme.css" ]]; then
      minify_css "$SRC/themes/$t/theme.css" "$OUT/themes/$t.min.css"
    else
      echo "[build] WARN: theme not found: $SRC/themes/$t/theme.css" >&2
    fi
  done

  # ---------------------------
# Overrides bundle
# ---------------------------
if [[ -f "$REPO_ROOT/$SP_OVERRIDES_FILE" ]]; then
  minify_css "$REPO_ROOT/$SP_OVERRIDES_FILE" "$OUT/overrides.min.css"
elif [[ -f "$SRC/overrides.css" ]]; then
  minify_css "$SRC/overrides.css" "$OUT/overrides.min.css"
else
  : > "$OUT/overrides.min.css"
fi

  echo "[build] generated: framework/cdn/$SP_CDN_VERSION"
  ls -la "$OUT" || true
}

# ---- 2) Package a clean CDN layout at ./cdn/<version>/{css,themes,js} ----
package_cdn_layout() {
  local SRC_BASE="$REPO_ROOT/framework/cdn/$SP_CDN_VERSION"

  local DST_BASE="$REPO_ROOT/cdn/$SP_CDN_VERSION"
  local DST_CSS="$DST_BASE/css"
  local DST_THEMES="$DST_BASE/themes"
  local DST_JS="$DST_BASE/js"

  mkdir -p "$DST_CSS" "$DST_THEMES" "$DST_JS"

  echo "[build] packaging CDN layout:"
  echo "        from: $SRC_BASE"
  echo "        to:   $DST_BASE"

  # Core CSS
  cp -f "$SRC_BASE/spectra.min.css" "$DST_CSS/spectra.min.css"

  # Overrides
  if [[ -f "$SRC_BASE/overrides.min.css" ]]; then
    cp -f "$SRC_BASE/overrides.min.css" "$DST_CSS/overrides.min.css"
  fi

  # Themes
  if [[ -d "$SRC_BASE/themes" ]]; then
    if have_cmd rsync; then
      rsync -a --delete "$SRC_BASE/themes/" "$DST_THEMES/"
    else
      rm -rf "$DST_THEMES" && mkdir -p "$DST_THEMES"
      cp -R "$SRC_BASE/themes/." "$DST_THEMES/"
    fi
  fi

  # Default theme bundle
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