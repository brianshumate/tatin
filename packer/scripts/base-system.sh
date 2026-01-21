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
  git \
  curl \
  wget \
  jq \
  unzip \
  ca-certificates \
  gnupg \
  locales-all \
  lsb-release

echo "○ Installing shell tools..."
sudo -E apt-get install -y -qq \
  tmux \
  zsh \
  vim \
  htop \
  tree

echo "○ Installing Ruby build dependencies..."
sudo -E apt-get install -y -qq \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  libyaml-dev \
  libffi-dev

echo "● Base system ready"
