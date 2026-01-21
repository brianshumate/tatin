#!/usr/bin/env bash
# Crush provisioning for Tatin (runs as admin user)
set -euo pipefail

MISE_BIN="$HOME/.local/bin/mise"

echo "○ Installing Crush..."

# Install via mise's npm (uses registry integrity verification)
# npm verifies package checksums via package-lock.json
echo "  ◐ Installing @charmland/crush from npm registry"

# Use mise exec to run npm with the mise-managed Node.js
$MISE_BIN exec -- npm install -g @charmland/crush

# Verify installation using mise exec
if $MISE_BIN exec -- which crush &> /dev/null; then
  echo "● Crush ready"
else
  echo "● Crush installed (available after shell restart)"
fi
