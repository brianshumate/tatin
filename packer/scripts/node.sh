#!/usr/bin/env bash
# Node.js installation for Tatin using mise
# Installs the latest LTS version of Node.js
# https://mise.jdx.dev/
set -euo pipefail

MISE_BIN="/usr/bin/mise"

# Check if mise is installed
if [ ! -x "$MISE_BIN" ]; then
  echo "Error: mise not found at $MISE_BIN"
  echo "Run mise.sh first to install mise"
  exit 1
fi

echo "○ Installing Node.js (LTS) via mise..."

# Install latest LTS version of Node.js
$MISE_BIN use --global node@lts

# Verify Node.js is installed
NODE_BIN="$($MISE_BIN which node 2>/dev/null || true)"
if [ -z "$NODE_BIN" ] || [ ! -x "$NODE_BIN" ]; then
  echo "Error: Node.js installation failed"
  exit 1
fi

echo "● Node.js $($NODE_BIN --version) installed"
echo "● npm $(npm --version) installed"

# Display installation location
echo "○ Node.js location: $NODE_BIN"
