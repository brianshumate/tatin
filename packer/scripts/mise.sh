#!/usr/bin/env bash
# Mise (mise-en-place) provisioning for Tatin
# Installs mise, configures it, and installs all development tools
# Includes: Python, Go, Node.js, Rust, and Bun
# https://mise.jdx.dev/
set -euo pipefail

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

# Enable parallel compilation for faster builds
export MAKEFLAGS="-j$(nproc)"
export CARGO_BUILD_JOBS=$(nproc)

MISE_BIN="/usr/bin/mise"

INSTALL_TIMEOUT=240

# Function to install a tool with timeout and progress
mise_tool() {
    local tool_version="$1"

    echo "  Installing ${tool_version}..."

    if timeout "${INSTALL_TIMEOUT}" "$MISE_BIN" install --yes \
        "${tool_version}" 2>&1; then
        echo "  ✓ ${tool_version} installed successfully"
        return 0
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo "  ✗ ${tool_version} timed out after ${INSTALL_TIMEOUT}s"
        else
            echo "  ✗ ${tool_version} failed with exit code ${exit_code}"
        fi
        return $exit_code
    fi
}

echo "○ Installing mise via apt..."

# Install mise using the official apt repository
# sudo DEBIAN_FRONTEND=noninteractive apt update -y && \
sudo install -dm 755 /etc/apt/keyrings && \
curl -fSs https://mise.jdx.dev/gpg-key.pub | \
sudo tee /etc/apt/keyrings/mise-archive-keyring.asc 1> /dev/null && \
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list && \
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y && \
sudo  DEBIAN_FRONTEND=noninteractive apt-get install -y mise

# Verify mise is installed
if [ ! -x "$MISE_BIN" ]; then
  echo "Error: mise installation failed"
  exit 1
fi

echo "● mise $($MISE_BIN --version) installed"

# Add mise shell activation to .bashrc for global tool access
BASHRC="$HOME/.bashrc"
if ! grep -q 'mise activate' "$BASHRC" 2>/dev/null; then
  echo '' >> "$BASHRC"
  echo '# Mise shell integration for global tool access' >> "$BASHRC"
  echo 'eval "$(mise activate bash)"' >> "$BASHRC"
  echo 'eval "$(mise completion bash)"' >> "$BASHRC"
fi

# Create global config directory
mkdir -p ~/.config/mise

# Copy global mise configuration
# This file defines Bun, Go, Node.js, Python, and Rust
if [ -f /tmp/mise.toml ]; then
  cp /tmp/mise.toml ~/.config/mise/config.toml
  echo "○ Mise configuration installed"
else
  echo "Warning: /tmp/mise.toml not found, manual command fallback"
  # Fallback: use mise use to set up tools
  $MISE_BIN use --global python@3
  $MISE_BIN use --global go@1.23
  $MISE_BIN use --global node@24
  $MISE_BIN use --global rust@latest
  $MISE_BIN use --global bun@1.2
fi

# Create work directory for mise.toml placement
if [ ! -d ~/work ]; then
  mkdir -p ~/work
fi

# Clean up tracked config directory to prevent "File exists" warnings
mkdir -p ~/.local/state/mise/tracked-configs
rm -rf ~/.local/state/mise/tracked-configs/* 2>/dev/null || true

# Trust the global config (allows mise to run without prompts)
$MISE_BIN trust --all 2>/dev/null || true

# Enable parallel installation (4 concurrent jobs)
$MISE_BIN settings jobs 4

echo "○ Installing development tools via mise (parallel with 4 jobs)..."
echo "  Timeout: ${INSTALL_TIMEOUT}s for entire installation..."

# Install all tools from config.toml in parallel
set +e  # Don't exit immediately on error
if timeout "${INSTALL_TIMEOUT}" "$MISE_BIN" install --yes 2>&1; then
    echo "● All tools installed successfully"
else
    exit_code=$?
    if [ $exit_code -eq 124 ]; then
        echo "✗ Installation timed out after ${INSTALL_TIMEOUT}s"
    else
        echo "✗ Installation failed with exit code ${exit_code}"
    fi
    echo "Continuing with remaining setup..."
fi
set -e

echo ""
echo "● Mise tools installed:"
$MISE_BIN ls

# Verify mise setup with doctor
# echo ""
# echo "○ Running mise doctor to verify setup..."
# $MISE_BIN doctor || echo "Warning: mise doctor reported issues"
