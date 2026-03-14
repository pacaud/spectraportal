#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# SpectraPortal Build
#
# Current build target:
# - cdn: builds versioned + latest CDN bundles from framework
#
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_build.sh cdn
#   SP_CDN_VERSION=v0.1 scripts/sp_build.sh cdn --repo /path/to/repo
#   SP_CDN_VERSION=v0.1 scripts/sp_build.sh cdn --repo /path/to/repo --src framework
#
# Notes:
# - dev/ (from ./docs), assets/, framework/, gate/, hollowverse/, gate-draft/, and srv are source targets
#   and do not currently require a build step.
# - The target name is `dev`, but it deploys the local ./docs source tree by default.
# - This script does NOT require npm/package.json.
# - Raw framework sources are not deployed to the CDN host.
# ============================================================

usage() {
  cat <<'EOF'
Usage:
  sp_build.sh <target> [--repo PATH] [--src PATH]

Targets:
  cdn         Build versioned + latest CDN bundles from framework
  assets      No build step required
  framework   No build step required
  dev         No build step required
  gate        No build step required
  hollowverse No build step required
  gate-draft  No build step required
  srv         No build step required
  docs        Alias of dev (no build step required)

Options:
  --repo PATH Repo root to use instead of the parent of this script
  --src PATH  Source folder for cdn builds (default: framework)
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
      [[ $# -ge 2 ]] || { echo "[build] ERROR: --repo requires a path" >&2; exit 1; }
      REPO_OVERRIDE="$2"
      shift 2
      ;;
    --src)
      [[ $# -ge 2 ]] || { echo "[build] ERROR: --src requires a path" >&2; exit 1; }
      SRC_OVERRIDE="$2"
      shift 2
      ;;
    --*)
      echo "[build] ERROR: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
      else
        echo "[build] ERROR: unexpected argument: $1" >&2
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
if [[ -n "$REPO_OVERRIDE" ]]; then
  REPO_ROOT="$(cd "$REPO_OVERRIDE" && pwd)"
else
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

if [[ "$TARGET" == "docs" ]]; then
  TARGET="dev"
fi

if [[ "$TARGET" != "cdn" ]]; then
  echo "[build] target: $TARGET (no build step required)"
  exit 0
fi

if [[ -n "$SRC_OVERRIDE" ]]; then
  if [[ "$SRC_OVERRIDE" = /* ]]; then
    SRC="$SRC_OVERRIDE"
  else
    SRC="$REPO_ROOT/$SRC_OVERRIDE"
  fi
else
  SRC="$REPO_ROOT/framework"
fi

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

  if command -v python3 >/dev/null 2>&1; then
    python3 - "$IN" "$OUT" <<'PY'
from pathlib import Path
import sys

src = Path(sys.argv[1]).read_text(encoding="utf-8")
out_path = Path(sys.argv[2])

result = []
in_comment = False
in_string = False
quote = ""
escape = False
pending_space = False
i = 0
n = len(src)

while i < n:
    ch = src[i]

    if in_comment:
        if ch == "*" and i + 1 < n and src[i + 1] == "/":
            in_comment = False
            i += 2
            continue
        i += 1
        continue

    if in_string:
        result.append(ch)
        if escape:
            escape = False
        elif ch == "\":
            escape = True
        elif ch == quote:
            in_string = False
            quote = ""
        i += 1
        continue

    if ch == "/" and i + 1 < n and src[i + 1] == "*":
        in_comment = True
        i += 2
        continue

    if ch in ('"', "'"):
        if pending_space and result and result[-1] not in "{(:,;>+~/":
            result.append(" ")
        pending_space = False
        result.append(ch)
        in_string = True
        quote = ch
        i += 1
        continue

    if ch in " \t\r\n\f":
        pending_space = True
        i += 1
        continue

    if ch in "{}:;,>+~=)":
        while result and result[-1] == " ":
            result.pop()
        result.append(ch)
        pending_space = False
        i += 1
        continue

    if ch == "(":
        while result and result[-1] == " ":
            result.pop()
        result.append(ch)
        pending_space = False
        i += 1
        continue

    if pending_space and result and result[-1] not in "{(:,;>+~/":
        result.append(" ")
    pending_space = False
    result.append(ch)
    i += 1

minified = ''.join(result).strip()
out_path.write_text(minified + ("\n" if minified else ""), encoding="utf-8")
PY
    return 0
  fi

  sed -E 's/[[:space:]]+$//' "$IN" | awk 'NF{p=1} p{print}' > "$OUT"
}

bundle_and_minify () {
  local OUT="$1"
  shift || true
  local FILES=("$@")

  if [[ ${#FILES[@]} -eq 0 ]]; then
    : > "$OUT"
    return 1
  fi

  local TMP_FILE
  TMP_FILE="$(mktemp)"
  cat "${FILES[@]}" > "$TMP_FILE"
  minify_css "$TMP_FILE" "$OUT"
  rm -f "$TMP_FILE"
  return 0
}

echo "[build] building version $SP_CDN_VERSION"
echo "[build] repo: $REPO_ROOT"
echo "[build] src:  $SRC"

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

shopt -s nullglob
DEFAULT_THEME_FILES=()

if [[ -f "$SRC/themes/themes.css" ]]; then
  DEFAULT_THEME_FILES+=("$SRC/themes/themes.css")
elif [[ -f "$SRC/themes/spectra-midnight/theme.css" ]]; then
  DEFAULT_THEME_FILES+=("$SRC/themes/spectra-midnight/theme.css")
  for F in "$SRC/themes/spectra-midnight/theme-bits/"*.css; do
    DEFAULT_THEME_FILES+=("$F")
  done
elif [[ -f "$SRC/theme.css" ]]; then
  DEFAULT_THEME_FILES+=("$SRC/theme.css")
else
  for DIR in "$SRC/themes/spectra-midnight" "$SRC/themes/"*/; do
    [[ -d "$DIR" ]] || continue

    CANDIDATES=()
    if [[ -f "$DIR/theme.css" ]]; then
      CANDIDATES+=("$DIR/theme.css")
    fi
    for F in "$DIR/theme-bits/"*.css; do
      CANDIDATES+=("$F")
    done

    if [[ ${#CANDIDATES[@]} -gt 0 ]]; then
      DEFAULT_THEME_FILES+=("${CANDIDATES[@]}")
      break
    fi
  done
fi

if [[ ${#DEFAULT_THEME_FILES[@]} -gt 0 ]]; then
  echo "[build] default theme -> ${DEFAULT_THEME_FILES[*]#$REPO_ROOT/}"
  bundle_and_minify "$CDN_OUT/themes/theme.min.css" "${DEFAULT_THEME_FILES[@]}"
else
  echo "[build] WARN: no default theme source found; writing empty theme.min.css"
  : > "$CDN_OUT/themes/theme.min.css"
fi

if [[ -d "$SRC/themes" ]]; then
  for DIR in "$SRC/themes/"*/; do
    [[ -d "$DIR" ]] || continue
    NAME="$(basename "$DIR")"

    THEME_FILES=()
    if [[ -f "$DIR/theme.css" ]]; then
      THEME_FILES+=("$DIR/theme.css")
    fi
    for F in "$DIR/theme-bits/"*.css; do
      THEME_FILES+=("$F")
    done

    if [[ ${#THEME_FILES[@]} -eq 0 ]]; then
      continue
    fi

    echo "[build] theme $NAME -> ${THEME_FILES[*]#$REPO_ROOT/}"
    bundle_and_minify "$CDN_OUT/themes/$NAME.min.css" "${THEME_FILES[@]}"
  done
fi

if [[ -f "$SRC/overrides.css" ]]; then
  minify_css "$SRC/overrides.css" "$CDN_OUT/css/overrides.min.css"
else
  : > "$CDN_OUT/css/overrides.min.css"
fi

rm -rf "$LATEST_OUT"
mkdir -p "$LATEST_OUT"
cp -a "$CDN_OUT/." "$LATEST_OUT/"

echo "[build] done"
