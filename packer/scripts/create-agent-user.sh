#!/usr/bin/env bash
# Create agent user with sudo capabilities
set -euo pipefail

AGENT_USERNAME="${AGENT_USERNAME:-agent}"
AGENT_PASSWORD="${AGENT_PASSWORD:-xmLGFhZqGlXvB2lJ/s+J8g=}"

echo "○ Creating agent user: ${AGENT_USERNAME}..."

# Create the user with home directory
sudo useradd -m -s /bin/bash "${AGENT_USERNAME}"

# Set password for the user
echo "${AGENT_USERNAME}:${AGENT_PASSWORD}" | sudo chpasswd

# Add user to sudo group
sudo usermod -aG sudo "${AGENT_USERNAME}"

# Configure sudoers to allow password-less sudo for the agent user
echo "${AGENT_USERNAME} ALL=(ALL) NOPASSWD:ALL" \
| sudo tee "/etc/sudoers.d/${AGENT_USERNAME}" > /dev/null
sudo chmod 440 "/etc/sudoers.d/${AGENT_USERNAME}"

# Set home directory permissions to allow packer's file provisioner
# (running as admin) to write The admin user is in the sudo group,
# so we allow group write access
sudo chmod 775 "/home/${AGENT_USERNAME}"
sudo chown "${AGENT_USERNAME}:sudo" "/home/${AGENT_USERNAME}"

echo "● Agent user ${AGENT_USERNAME} created with sudo capabilities"

# Starship prompt configuration for agent user
sudo mkdir -p "/home/${AGENT_USERNAME}/.config"
sudo starship preset nerd-font-symbols -o "/home/${AGENT_USERNAME}/.config/starship.toml"

# Ensure agent user owns all files and directories in their home
sudo chown -R "${AGENT_USERNAME}:${AGENT_USERNAME}" "/home/${AGENT_USERNAME}"
