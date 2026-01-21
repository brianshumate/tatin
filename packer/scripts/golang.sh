#!/usr/bin/env bash
# Go provisioning for Tatin
set -euo pipefail

GO_VERSION="${GO_VERSION:-1.23.5}"
echo "○ Installing Go ${GO_VERSION}..."

# Determine architecture
ARCH=$(dpkg --print-architecture)
case $ARCH in
  amd64) GO_ARCH="amd64" ;;
  arm64) GO_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Download and install Go
curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -o /tmp/go.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz

# Set up Go environment for all users
sudo tee /etc/profile.d/golang.sh > /dev/null << 'EOF'
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
EOF

echo "● Go ${GO_VERSION} ready"
