#!/usr/bin/env bash
set -euo pipefail

# Publish = build + deploy
#
# Usage:
#   SP_CDN_VERSION=v0.1 scripts/sp_publish.sh cdn
#   scripts/sp_publish.sh gate --repo /path/to/repo
#   scripts/sp_publish.sh gate --repo /path/to/repo --src gate
#   scripts/sp_publish.sh hollowverse --repo /path/to/repo
#   scripts/sp_publish.sh hollowverse --repo /path/to/repo --src gate/hollowverse
#   scripts/sp_publish.sh gate-draft --repo /path/to/repo
#   scripts/sp_publish.sh gate-draft --repo /path/to/repo --src gate/drafts
#   scripts/sp_publish.sh srv --repo /path/to/repo
#   scripts/sp_publish.sh dev --repo /path/to/repo --src docs
#
# Notes:
# - All options after <target> are forwarded to both build and deploy.
# - For non-cdn targets, build is currently a no-op.
# - gate deploys only the public Gate site from repo/gate.
# - gate excludes repo/gate/boot, repo/gate/chat_center, repo/gate/core, and repo/gate/hollowverse from the Gate webroot sync.
# - hollowverse deploys only repo/gate/hollowverse to gate.spectraportal.dev/hollowverse.
# - gate-draft syncs only the private Gate drafts workspace from repo/gate/drafts.
# - srv syncs repo/gate/boot, repo/gate/chat_center, repo/gate/core, and repo/gate/hollowverse into /srv/spectraportal.

usage() {
  cat <<'EOF'
Usage:
  sp_publish.sh <target> [--repo PATH] [--src PATH]

Targets:
  cdn         Publish CDN assets
  gate        Publish the public Gate site only
  hollowverse Publish the public Gate Hollowverse endpoint only
  gate-draft  Publish the private Gate drafts workspace only
  srv         Sync gate/boot, gate/chat_center, gate/core, and gate/hollowverse into /srv/spectraportal
  dev         Publish a dev/docs target

Examples:
  scripts/sp_publish.sh gate --repo /mnt/pkw_ssd/pkw_repos/spectraportal
  scripts/sp_publish.sh hollowverse --repo /mnt/pkw_ssd/pkw_repos/spectraportal
  scripts/sp_publish.sh gate-draft --repo /mnt/pkw_ssd/pkw_repos/spectraportal
  scripts/sp_publish.sh gate-draft --repo /mnt/pkw_ssd/pkw_repos/spectraportal --src gate/drafts
  scripts/sp_publish.sh srv --repo /mnt/pkw_ssd/pkw_repos/spectraportal
  scripts/sp_publish.sh gate --repo /mnt/pkw_ssd/pkw_repos/hollowverse-studio --src some/exported/gate
  scripts/sp_publish.sh hollowverse --repo /mnt/pkw_ssd/pkw_repos/hollowverse-studio --src gate/hollowverse
  SP_CDN_VERSION=v0.1 scripts/sp_publish.sh cdn --repo /mnt/pkw_ssd/pkw_repos/spectraportal
EOF
}

TARGET="${1:-cdn}"
shift || true

if [[ "$TARGET" == "-h" || "$TARGET" == "--help" ]]; then
  usage
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/sp_build.sh" "$TARGET" "$@"
"$SCRIPT_DIR/sp_deploy.sh" "$TARGET" "$@"
