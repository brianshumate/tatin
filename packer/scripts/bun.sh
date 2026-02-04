#!/usr/bin/env bash
# Bun installation for Tatin
# Installs bun using curlbash from bun.sh (official method)
# https://bun.sh/docs/installation
set -euo pipefail

BUN_INSTALL_DIR="$HOME/.bun"

echo "○ Installing bun via curlbash from bun.sh..."

# Skip /etc/profile.d/bun.sh creation - bun is already added to ~/.bashrc
export BUN_INSTALL_SKIP_PROFILE=1

# Use the official curlbash installer with retry logic for network resilience
curl --retry 3 --retry-delay 2 --retry-max-time 60 -fsSL https://bun.sh/install | bash

# Verify bun is installed
BUN_BIN="$BUN_INSTALL_DIR/bin/bun"
if [ ! -x "$BUN_BIN" ]; then
  echo "Error: bun installation failed"
  exit 1
fi

echo "● bun $($BUN_BIN --version) installed at $BUN_BIN"

# Skip /etc/profile.d/bun.sh creation - already handled by BUN_INSTALL_SKIP_PROFILE
echo "● Bun installation complete"
