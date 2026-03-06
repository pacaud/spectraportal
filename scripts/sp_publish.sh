#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-cdn}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/sp_build.sh" "$TARGET"
"$SCRIPT_DIR/sp_deploy.sh" "$TARGET"
