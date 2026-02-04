#!/usr/bin/env bash
# Bun installation for Tatin
# Installs bun using curlbash from bun.sh (official method)
# https://bun.sh/docs/installation
set -euo pipefail

BUN_INSTALL_DIR="$HOME/.bun"

echo "○ Installing bun via curlbash from bun.sh..."

# Use the official curlbash installer with retry logic for network resilience
curl --retry 3 --retry-delay 2 --retry-max-time 60 -fsSL https://bun.sh/install | bash

# Verify bun is installed
BUN_BIN="$BUN_INSTALL_DIR/bin/bun"
if [ ! -x "$BUN_BIN" ]; then
  echo "Error: bun installation failed"
  exit 1
fi

echo "● bun $($BUN_BIN --version) installed at $BUN_BIN"

# Add bun to PATH in .bashrc for interactive shells
BASHRC="$HOME/.bashrc"
if ! grep -q 'bun/bin' "$BASHRC" 2>/dev/null; then
  echo '' >> "$BASHRC"
  echo '# Bun (bun.sh) PATH' >> "$BASHRC"
  echo 'export PATH="$HOME/.bun/bin:$PATH"' >> "$BASHRC"
  echo 'export BUN_INSTALL="$HOME/.bun"' >> "$BASHRC"
fi

# Add bun to /etc/profile.d/ for system-wide access (if running as root/sudo context)
if [ -d /etc/profile.d ] && [ ! -f /etc/profile.d/bun.sh ]; then
  echo 'export PATH="$HOME/.bun/bin:$PATH"' > /etc/profile.d/bun.sh
  echo 'export BUN_INSTALL="$HOME/.bun"' >> /etc/profile.d/bun.sh
  chmod 644 /etc/profile.d/bun.sh
fi

echo "● Bun installation complete"
