#!/usr/bin/env bash
set -euo pipefail

# Publish = build + deploy
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_publish.sh cdn
#   scripts/sp_publish.sh framework

TARGET="${1:-cdn}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/sp_build.sh" "$TARGET"
"$SCRIPT_DIR/sp_deploy.sh" "$TARGET"
