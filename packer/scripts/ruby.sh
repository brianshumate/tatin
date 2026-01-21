#!/usr/bin/env bash
# Ruby provisioning for Tatin via rbenv (runs as admin user)
set -euo pipefail

RUBY_VERSION="${RUBY_VERSION:-3.3.6}"

echo "○ Installing rbenv and ruby-build..."

# Clone rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Clone ruby-build plugin
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Set up PATH for current session
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(~/.rbenv/bin/rbenv init - bash)"

# Add rbenv to bashrc if not already present
if ! grep -q 'rbenv' ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc << 'EOF'

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
EOF
fi

echo "○ Installing Ruby ${RUBY_VERSION} (this may take a few minutes)..."
rbenv install "$RUBY_VERSION"
rbenv global "$RUBY_VERSION"

# Verify installation
if command -v ruby &> /dev/null; then
  echo "● Ruby $(ruby --version | cut -d' ' -f2) ready"
else
  echo "● Ruby ${RUBY_VERSION} installed (available after shell restart)"
fi
