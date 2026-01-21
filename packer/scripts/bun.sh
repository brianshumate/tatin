#!/usr/bin/env bash
# Bun provisioning for Tatin (runs as admin user)
set -euo pipefail

echo "○ Installing Bun..."
curl -fsSL https://bun.sh/install | bash

# Add to PATH for current session
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ensure PATH is in bashrc
if ! grep -q 'BUN_INSTALL' ~/.bashrc 2>/dev/null; then
  echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
  echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
fi

# Verify installation
if command -v bun &> /dev/null; then
  echo "● Bun $(bun --version) ready"
else
  echo "● Bun installed (available after shell restart)"
fi
