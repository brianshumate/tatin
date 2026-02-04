#!/usr/bin/env bash
# Agent tools provisioning for Tatin (Claude Code + OpenCode)
# Runs both installations in parallel since they only depend on curl
set -euo pipefail

INSTALL_CLAUDE_URL="https://claude.ai/install.sh"
INSTALL_OPENCODE_URL="https://opencode.ai/install"

echo "○ Installing agent tools in parallel..."

# Install Claude Code in background
(
  echo "  ◐ Installing Claude Code..."
  CLAUDE_SCRIPT=$(mktemp)
  trap 'rm -f "$CLAUDE_SCRIPT"' EXIT

  curl --retry 3 --retry-delay 2 --retry-max-time 60 -fsSL "$INSTALL_CLAUDE_URL" -o "$CLAUDE_SCRIPT"

  if [[ ! -s "$CLAUDE_SCRIPT" ]]; then
    echo "  ✗ Claude Code download failed"
    exit 1
  fi

  SCRIPT_HASH=$(sha256sum "$CLAUDE_SCRIPT" | cut -d' ' -f1)
  echo "  ◐ Claude installer SHA256: $SCRIPT_HASH"

  bash "$CLAUDE_SCRIPT"

  # Add to PATH
  export PATH="$HOME/.claude/bin:$PATH"

  # Ensure PATH is in bashrc
  if ! grep -q '.claude/bin' ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.claude/bin:$PATH"' >> ~/.bashrc
  fi

  if command -v claude &> /dev/null; then
    echo "  ● Claude Code ready"
  else
    echo "  ● Claude Code installed (available after shell restart)"
  fi
) &
CLAUDE_PID=$!

# Install OpenCode in background
(
  echo "  ◐ Installing OpenCode..."
  OPENCODE_SCRIPT=$(mktemp)
  trap 'rm -f "$OPENCODE_SCRIPT"' EXIT

  curl --retry 3 --retry-delay 2 --retry-max-time 60 -fsSL "$INSTALL_OPENCODE_URL" -o "$OPENCODE_SCRIPT"

  if [[ ! -s "$OPENCODE_SCRIPT" ]]; then
    echo "  ✗ OpenCode download failed"
    exit 1
  fi

  SCRIPT_HASH=$(sha256sum "$OPENCODE_SCRIPT" | cut -d' ' -f1)
  echo "  ◐ OpenCode installer SHA256: $SCRIPT_HASH"

  bash "$OPENCODE_SCRIPT"

  if command -v opencode &> /dev/null; then
    echo "  ● OpenCode ready"
  else
    echo "  ● OpenCode installed (available after shell restart)"
  fi
) &
OPENCODE_PID=$!

# Wait for both installations to complete
wait $CLAUDE_PID $OPENCODE_PID

echo "● Agent tools installation complete"
