#!/usr/bin/env bash
# Crush provisioning for Tatin (runs as admin user)
set -euo pipefail

MISE_BIN="$HOME/.local/bin/mise"

echo "○ Installing Crush..."

# Ensure mise is in PATH for npm post-install hooks that may call 'mise reshim'
export PATH="$HOME/.local/bin:$PATH"

# Install via mise's bun
echo "  ◐ Installing @charmland/crush from npm registry"

# Use mise exec to run npm with the mise-managed Node.js
$MISE_BIN exec -- bun install -g @charmland/crush

# Verify installation using mise exec
if $MISE_BIN exec -- which crush &> /dev/null; then
  echo "● Crush ready"
else
  echo "● Crush installed (available after shell restart)"
fi
