#!/usr/bin/env bash
# Node.js LTS provisioning for Tatin
set -euo pipefail

echo "○ Installing Node.js LTS..."

# Install Node.js from NodeSource
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
sudo apt-get install -y -qq nodejs

echo "● Node.js $(node --version) ready"
