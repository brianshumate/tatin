#!/usr/bin/env bash
# Final cleanup and configuration for Tatin
set -euo pipefail

# Ensure DEBIAN_FRONTEND is exported for sudo -E
export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

echo "○ Configure shell environment..."
echo "○ Clean up..."

# Reset home directory permissions to secure defaults
# (they were opened during provisioning to allow file uploads)
sudo chmod 755 "${HOME}"
sudo chown "${USER}:${USER}" "${HOME}"

# Clean apt cache to reduce image size
sudo -E apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Remove temporary files
sudo rm -rf /tmp/*

echo ""
echo "✓ Tatin sandbox image build complete."
echo ""
