#!/usr/bin/env bash
# Mise (mise-en-place) provisioning for Tatin
# Installs mise, configures it, and installs all development tools
# Note: Bun is installed separately via curlbash from bun.sh
# https://mise.jdx.dev/
set -euo pipefail

# Enable parallel compilation for faster builds
export MAKEFLAGS="-j$(nproc)"
export CARGO_BUILD_JOBS=$(nproc)

MISE_BIN="$HOME/.local/bin/mise"

# Timeout for each mise install command (in seconds)
INSTALL_TIMEOUT=600

# Function to install a tool with timeout and progress
mise_tool() {
    local tool_version="$1"

    echo "  Installing ${tool_version}..."

    # Use timeout command with 10 minute limit
    if timeout "${INSTALL_TIMEOUT}" "$MISE_BIN" install --yes "${tool_version}" 2>&1; then
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

echo "○ Installing mise..."

# Use the bash-specific installer with retry logic for network resilience
curl --retry 3 --retry-delay 2 --retry-max-time 60 -fsSL https://mise.run/bash | sh

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
  echo '# Mise (mise-en-place) shell integration for global tool access' >> "$BASHRC"
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$BASHRC"
  echo 'eval "$(mise completion bash)"' >> "$BASHRC"
fi

# Create global config directory
mkdir -p ~/.config/mise

# Copy global mise configuration (provided by Packer file provisioner)
# This file defines Python, Go, Node.js, and Rust (bun is installed separately)
if [ -f /tmp/mise.toml ]; then
  cp /tmp/mise.toml ~/.config/mise/config.toml
  echo "○ Mise configuration installed"
else
  echo "Warning: /tmp/mise.toml not found, using mise use commands instead"
  # Fallback: use mise use to set up tools
  $MISE_BIN use --global python@3
  $MISE_BIN use --global go@1.23
  $MISE_BIN use --global node@lts
  $MISE_BIN use --global rust@latest
fi

# Clean up tracked config directory to prevent "File exists" warnings
mkdir -p ~/.local/state/mise/tracked-configs
rm -rf ~/.local/state/mise/tracked-configs/* 2>/dev/null || true

# Trust the global config (allows mise to run without prompts)
$MISE_BIN trust --all 2>/dev/null || true

# Use default job settings (sequential within each tool)
$MISE_BIN settings jobs 0

echo "○ Installing development tools via mise (sequential)..."
echo "  Each tool has a ${INSTALL_TIMEOUT}s timeout..."

# Install tools sequentially with timeout and progress
set +e  # Don't exit on first error - continue to report all failures
FAILED_TOOLS=()

for tool_version in "python@3.12" "go@1.23.5" "node@22" "rust@1.84"; do
    if ! mise_tool ${tool_version}; then
        FAILED_TOOLS+=("${tool_version}")
    fi
done

set -e

# Report failures
if [ ${#FAILED_TOOLS[@]} -gt 0 ]; then
    echo ""
    echo "✗ The following tools failed to install:"
    for tool in "${FAILED_TOOLS[@]}"; do
        echo "  - ${tool}"
    done
    echo ""
    echo "Continuing with remaining setup..."
fi

echo ""
echo "● Mise tools installed:"
$MISE_BIN ls

# Verify mise setup with doctor
echo ""
echo "○ Running mise doctor to verify setup..."
$MISE_BIN doctor || echo "Warning: mise doctor reported issues"
