#!/usr/bin/env bash
# Final cleanup and configuration for Tatin
set -euo pipefail

# Ensure DEBIAN_FRONTEND is exported for sudo -E
export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

SSH_USERNAME="${SSH_USERNAME:-admin}"

echo "○ Configuring shell environment..."

# Set TERM for admin user
if ! grep -q 'TERM=xterm-256color' /home/"${SSH_USERNAME}"/.bashrc 2>/dev/null; then
  echo 'export TERM=xterm-256color' >> /home/"${SSH_USERNAME}"/.bashrc
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
