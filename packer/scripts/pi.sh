#!/usr/bin/env bash
# Pi for Tatin (runs as admin user)
set -euo pipefail

MISE_BIN="$HOME/.local/bin/mise"

echo "○ Installing Pi..."

# Ensure mise is in PATH for npm post-install hooks that may call 'mise reshim'
export PATH="$HOME/.local/bin:$PATH"

# Install via mise's bun
echo "  ◐ Installing @mariozechner/pi-coding-agent from npm registry"

# Use mise exec to run npm with the mise-managed Node.js
$MISE_BIN exec -- bun install -g @mariozechner/pi-coding-agent

# Verify installation using mise exec
if $MISE_BIN exec -- which pi &> /dev/null; then
  echo "● Pi ready"
else
  echo "● Pi installed (available after shell restart)"
fi
