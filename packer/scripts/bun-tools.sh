#!/usr/bin/env bash
# Bun-based tools provisioning for Tatin (Pi + Crush + qmd)
# Runs all three installations in parallel since they all use mise-managed bun
set -euo pipefail

MISE_BIN="$HOME/.local/bin/mise"

echo "○ Installing bun-based tools in parallel..."

# Ensure mise is in PATH
export PATH="$HOME/.local/bin:$PATH"

# Install Pi in background
(
  echo "  ◐ Installing Pi..."
  $MISE_BIN exec -- bun install -g @mariozechner/pi-coding-agent 2>/dev/null
  if $MISE_BIN exec -- which pi &> /dev/null; then
    echo "  ● Pi ready"
  else
    echo "  ● Pi installed (available after shell restart)"
  fi
) &
PI_PID=$!

# Install Crush in background
(
  echo "  ◐ Installing Crush..."
  $MISE_BIN exec -- bun install -g @charmland/crush 2>/dev/null
  if $MISE_BIN exec -- which crush &> /dev/null; then
    echo "  ● Crush ready"
  else
    echo "  ● Crush installed (available after shell restart)"
  fi
) &
CRUSH_PID=$!

# Install qmd in background
(
  echo "  ◐ Installing qmd..."
  $MISE_BIN exec -- bun install -g https://github.com/tobi/qmd 2>/dev/null
  if $MISE_BIN exec -- which qmd &> /dev/null; then
    echo "  ● qmd ready"
  else
    echo "  ● qmd installed (available after shell restart)"
  fi
) &
QMD_PID=$!

# Wait for all installations to complete
wait $PI_PID $CRUSH_PID $QMD_PID

echo "● Bun-based tools installation complete"
