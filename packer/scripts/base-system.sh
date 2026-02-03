#!/usr/bin/env bash
# Base system provisioning for Tatin
set -euo pipefail

# Ensure DEBIAN_FRONTEND is exported for sudo -E
export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

echo "○ Updating package lists..."
sudo -E apt-get update -qq

echo "○ Installing all system packages..."
sudo -E apt-get install -y -qq \
  build-essential \
  git \
  curl \
  wget \
  jq \
  unzip \
  ca-certificates \
  gnupg \
  locales-all \
  lsb-release \
  tmux \
  zsh \
  vim \
  htop \
  tree \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  libyaml-dev \
  libffi-dev

echo "● Base system ready"
