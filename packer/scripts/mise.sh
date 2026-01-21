#!/usr/bin/env bash
# Mise (mise-en-place) provisioning for Tatin
# Installs mise, configures it, and installs all development tools
# https://mise.jdx.dev/
set -euo pipefail

MISE_BIN="$HOME/.local/bin/mise"

echo "○ Installing mise..."

# Use the bash-specific installer which handles both installation and activation
curl -fsSL https://mise.run/bash | sh

# Verify mise is installed
if [ ! -x "$MISE_BIN" ]; then
  echo "Error: mise installation failed"
  exit 1
fi

echo "● mise $($MISE_BIN --version) installed"

# Create global config directory
mkdir -p ~/.config/mise

# Copy global mise configuration (provided by Packer file provisioner)
# This file defines Python, Go, Node.js, Ruby, Bun, and Rust
if [ -f /tmp/mise.toml ]; then
  cp /tmp/mise.toml ~/.config/mise/config.toml
  echo "○ Mise configuration installed"
else
  echo "Warning: /tmp/mise.toml not found, using mise use commands instead"
  # Fallback: use mise use to set up tools
  $MISE_BIN use --global python@3
  $MISE_BIN use --global go@1.23
  $MISE_BIN use --global node@lts
  $MISE_BIN use --global ruby@3.3
  $MISE_BIN use --global bun@latest
  $MISE_BIN use --global rust@latest
fi

# Trust the global config (allows mise to run without prompts)
$MISE_BIN trust --all 2>/dev/null || true

echo "○ Installing development tools via mise..."
echo "  This may take several minutes (compiling Ruby, etc.)..."

# Install all tools defined in the global config
$MISE_BIN install --yes

echo ""
echo "● Mise tools installed:"
$MISE_BIN ls
