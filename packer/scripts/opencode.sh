#!/usr/bin/env bash
# OpenCode provisioning for Tatin (runs as agent user)
set -euo pipefail

INSTALL_URL="https://opencode.ai/install"
INSTALL_SCRIPT=$(mktemp)
trap 'rm -f "$INSTALL_SCRIPT"' EXIT

echo "○ Installing OpenCode..."

# Download installer script (don't pipe directly to bash)
echo "  ◐ Downloading installer from $INSTALL_URL"
curl \
    --retry 3 \
    --retry-delay 2 \
    --retry-max-time 60 \
    -fsSL "$INSTALL_URL" -o "$INSTALL_SCRIPT"

# Basic validation
if [[ ! -s "$INSTALL_SCRIPT" ]]; then
  echo "  ✗ Downloaded script is empty"
  exit 1
fi

# Log script hash for audit trail
SCRIPT_HASH=$(sha256sum "$INSTALL_SCRIPT" | cut -d' ' -f1)
echo "  ◐ Installer SHA256: $SCRIPT_HASH"

# Execute downloaded script
bash "$INSTALL_SCRIPT"

if command -v opencode &> /dev/null; then
  echo "● OpenCode ready"
else
  echo "● OpenCode installed (available after shell restart)"
fi
