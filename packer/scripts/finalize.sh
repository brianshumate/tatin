#!/usr/bin/env bash
# Final cleanup and configuration for Tatin
set -euo pipefail

# Ensure DEBIAN_FRONTEND is exported for sudo -E
export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

SSH_USERNAME="${SSH_USERNAME:-admin}"
BASHRC="/home/${SSH_USERNAME}/.bashrc"

echo "○ Configuring shell environment..."

# Set TERM for admin user
if ! grep -q 'TERM=xterm-256color' "$BASHRC" 2>/dev/null; then
  echo 'export TERM=xterm-256color' >> "$BASHRC"
fi

# Add mise shell activation for global tool access
if ! grep -q 'mise activate' "$BASHRC" 2>/dev/null; then
  echo '' >> "$BASHRC"
  echo '# Mise (mise-en-place) shell integration for global tool access' >> "$BASHRC"
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$BASHRC"
fi

# Add mise bash completions
if ! grep -q 'mise completions' "$BASHRC" 2>/dev/null; then
  echo '# Mise bash completions' >> "$BASHRC"
  echo 'eval "$(mise completion bash)"' >> "$BASHRC"
fi

# Remove redundant bun PATH addition (mise handles this)
sed -i '/\.bun\/bin/d' "$BASHRC" 2>/dev/null || true

# Add claude alias with --dangerously-skip-permissions flag
if ! grep -q 'alias claude=' "$BASHRC" 2>/dev/null; then
  echo "alias claude='claude --dangerously-skip-permissions'" >> "$BASHRC"
fi

echo "○ Cleaning up..."

# Clean apt cache to reduce image size
sudo -E apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Remove temporary files
sudo rm -rf /tmp/*

echo ""
echo "✓ Tatin sandbox ready!"
echo ""
echo "Development environment:"
echo "  ○ mise (version manager) - manages all language runtimes"
echo "  ○ Python, Go, Node.js, Ruby, Bun, Rust (via mise)"
echo "  ○ build-essential, git, jq, tmux, zsh, vim"
echo ""
echo "AI agent tools:"
echo "  ○ Claude Code"
echo "  ○ OpenCode"
echo "  ○ Crush"
