#!/usr/bin/env bash
# Crush provisioning for Tatin (runs as admin user)
set -euo pipefail

echo "○ Installing Crush..."

# Ensure bun is in PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Install via npm/bun (uses registry integrity verification)
# npm verifies package checksums via package-lock.json
echo "  ◐ Installing @charmland/crush from npm registry"
npm install -g @charmland/crush 2>/dev/null || bun install -g @charmland/crush

if command -v crush &> /dev/null; then
  echo "● Crush ready"
else
  echo "● Crush installed (available after shell restart)"
fi
