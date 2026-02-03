#!/usr/bin/env bash
# qmd provisioning for Tatin (runs as admin user)
set -euo pipefail

MISE_BIN="$HOME/.local/bin/mise"

echo "○ Installing Crush..."

# Ensure mise is in PATH for npm post-install hooks that may call 'mise reshim'
export PATH="$HOME/.local/bin:$PATH"

# Install via mise's bun
echo "  ◐ Installing qmd"

# Install qmd with bun
$MISE_BIN exec -- bun install -g https://github.com/tobi/qmd

# Verify installation
if $MISE_BIN exec -- which qmd &> /dev/null; then
  echo "● qmd ready"
else
  echo "● qmd installed"
fi
