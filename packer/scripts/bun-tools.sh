#!/usr/bin/env bash
# Bun-based tools provisioning for Tatin (Pi + Crush + qmd)
# Uses officially installed bun from bun.sh (curlbash method), not mise
set -euo pipefail

BUN_BIN="$HOME/.bun/bin/bun"

echo "○ Installing bun-based tools in parallel..."

# Ensure bun is in PATH
export PATH="$HOME/.bun/bin:$PATH"

# Install Pi in background
(
  echo "  ◐ Installing Pi..."
  $BUN_BIN install -g @mariozechner/pi-coding-agent 2>/dev/null
  if which pi &> /dev/null; then
    echo "  ● Pi ready"
  else
    echo "  ● Pi installed (available after shell restart)"
  fi
) &
PI_PID=$!

# Install Crush in background
(
  echo "  ◐ Installing Crush..."
  $BUN_BIN install -g @charmland/crush 2>/dev/null
  if which crush &> /dev/null; then
    echo "  ● Crush ready"
  else
    echo "  ● Crush installed (available after shell restart)"
  fi
) &
CRUSH_PID=$!

# Install qmd in background
(
  echo "  ◐ Installing qmd..."
  $BUN_BIN install -g https://github.com/tobi/qmd 2>/dev/null
  if which qmd &> /dev/null; then
    echo "  ● qmd ready"
  else
    echo "  ● qmd installed (available after shell restart)"
  fi
) &
QMD_PID=$!

# Wait for all installations to complete
wait $PI_PID $CRUSH_PID $QMD_PID

echo "● Bun-based tools installation complete"
