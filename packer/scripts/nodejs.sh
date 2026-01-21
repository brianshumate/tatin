#!/usr/bin/env bash
# Node.js LTS provisioning for Tatin
set -euo pipefail

# Ensure DEBIAN_FRONTEND is exported for sudo -E
export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

echo "○ Installing Node.js LTS..."

# Install Node.js from NodeSource (use sudo -E to preserve DEBIAN_FRONTEND)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo -E apt-get install -y -qq nodejs

echo "● Node.js $(node --version) ready"
