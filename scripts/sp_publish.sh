#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   scripts/sp_publish.sh [target]
# Examples:
#   scripts/sp_publish.sh framework
#   scripts/sp_publish.sh devhub
#   scripts/sp_publish.sh portal
#   scripts/sp_publish.sh lab

TARGET="${1:-devhub}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/sp_build_updated.sh" "$TARGET"
"$SCRIPT_DIR/sp_deploy_updated.sh" "$TARGET"
