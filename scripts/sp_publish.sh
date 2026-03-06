#!/usr/bin/env bash
set -euo pipefail

# Publish = build + deploy
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_publish.sh cdn
#   scripts/sp_publish.sh assets
#   scripts/sp_publish.sh framework
#   scripts/sp_publish.sh dev
#   scripts/sp_publish.sh docs   # compatibility alias

TARGET="${1:-cdn}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/sp_build.sh" "$TARGET"
"$SCRIPT_DIR/sp_deploy.sh" "$TARGET"
