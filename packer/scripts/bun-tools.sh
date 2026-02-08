#!/usr/bin/env bash
# Bun-based tools provisioning for Tatin (Pi + Crush + qmd)
# Uses mise-installed bun
# Note: Tools are installed globally via mise's bun
set -euo pipefail

echo "○ Installing bun-based tools in parallel..."

# Ensure mise is activated so bun is available
if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

# Verify bun is available
if ! command -v bun &> /dev/null; then
  echo "Error: bun not found - mise should have installed it"
  exit 1
fi

BUN_BIN="$(command -v bun)"
echo "  Using bun from mise: $BUN_BIN"

# Install Pi in background
(
  echo "  ◐ Installing Pi..."
  $BUN_BIN install -g @mariozechner/pi-coding-agent 2>/dev/null
  if command -v pi &> /dev/null; then
    echo "  ● Pi ready"
  else
    echo "  ● Pi installed"
  fi
) &
PI_PID=$!

# Install Crush in background
(
  echo "  ◐ Installing Crush..."
  $BUN_BIN install -g @charmland/crush 2>/dev/null
  if command -v crush &> /dev/null; then
    echo "  ● Crush ready"
  else
    echo "  ● Crush installed"
  fi
) &
CRUSH_PID=$!

# Install qmd in background
(
  echo "  ◐ Installing qmd..."
  $BUN_BIN install -g https://github.com/tobi/qmd 2>/dev/null
  if command -v qmd &> /dev/null; then
    echo "  ● qmd ready"
  else
    echo "  ● qmd installed"
  fi
) &
QMD_PID=$!

# Wait for all installations to complete
wait $PI_PID $CRUSH_PID $QMD_PID

echo "● Bun-based tools installation complete"
