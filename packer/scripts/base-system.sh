#!/usr/bin/env bash
# Base system provisioning for Tatin
set -euo pipefail

# Ensure DEBIAN_FRONTEND is exported for sudo -E
export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

echo "○ Updating package lists..."
sudo -E apt-get update -qq

echo "○ Installing build-essential and core tools..."
sudo -E apt-get install -y -qq \
  build-essential \
  ca-certificates \
  curl \
  fd-find \
  git \
  gnupg \
  jq \
  locales-all \
  lsb-release \
  ripgrep \
  unzip \
  wget

echo "○ Installing shell tools..."
sudo -E apt-get install -y -qq \
  htop \
  tmux \
  tree \
  vim \
  zsh

echo "○ Installing language build dependencies for mise..."
sudo -E apt-get install -y -qq \
  libffi-dev \
  libreadline-dev \
  libssl-dev \
  libyaml-dev \
  zlib1g-dev
echo "● Base system ready"
