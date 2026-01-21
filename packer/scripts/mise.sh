#!/usr/bin/env bash
# Mise (mise-en-place) provisioning for Tatin
# Installs mise and sets up shell integration for the admin user
# https://mise.jdx.dev/
set -euo pipefail

echo "○ Installing mise..."

# Use the bash-specific installer which handles both installation and activation
curl -fsSL https://mise.run/bash | sh

# Source bashrc to get mise in current session
# shellcheck source=/dev/null
source ~/.bashrc 2>/dev/null || true

# Verify mise is installed
if command -v mise &> /dev/null; then
  echo "● mise $(mise --version) ready"
elif [ -x ~/.local/bin/mise ]; then
  echo "● mise $(~/.local/bin/mise --version) ready"
else
  echo "Error: mise installation failed"
  exit 1
fi

# Trust the global config directory (allows mise to run without prompts)
~/.local/bin/mise trust --all 2>/dev/null || true
