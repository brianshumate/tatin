#!/usr/bin/env bash
# Python 3 provisioning for Tatin
set -euo pipefail

echo "○ Installing Python 3..."
sudo apt-get install -y -qq \
  python3 \
  python3-pip \
  python3-venv \
  python3-dev

# Create symlinks if needed
if ! command -v python &> /dev/null; then
  sudo ln -sf /usr/bin/python3 /usr/bin/python
fi

echo "● Python $(python3 --version | cut -d' ' -f2) ready"
