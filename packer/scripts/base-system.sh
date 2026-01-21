#!/usr/bin/env bash
# Base system provisioning for Tatin
set -euo pipefail

echo "○ Updating package lists..."
sudo apt-get update -qq

echo "○ Installing build-essential and core tools..."
sudo apt-get install -y -qq \
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
sudo apt-get install -y -qq \
  tmux \
  zsh \
  vim \
  htop \
  tree

echo "● Base system ready"
