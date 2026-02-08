#!/usr/bin/env bash
# Bun verification and setup for Tatin
# Bun is now installed via mise, this script verifies it's available
# and sets up the environment for bun-based tools
# https://bun.sh/
set -euo pipefail

echo "○ Verifying bun installation via mise..."

# Ensure mise is activated so bun is available
if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
else
  echo "Error: mise not found"
  exit 1
fi

# Verify bun is installed and available
if ! command -v bun &> /dev/null; then
  echo "Error: bun not found - mise should have installed it"
  exit 1
fi

echo "● bun $(bun --version) is available via mise"

# Set up bun environment for global installations
export BUN_INSTALL="$HOME/.local/share/bun"
mkdir -p "$BUN_INSTALL"

echo "● Bun environment configured"
