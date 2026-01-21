# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Tatin is an LLM agent sandbox that combines Tart virtualization with Vagrant through the vagrant-tart plugin. It provisions a full Debian 13 development environment with sudo access, development tools (build-essential, git, jq, bun, python3, golang, tmux, zsh), and agent tools (Claude Code, Crush, OpenCode).

## Prerequisites

- [Tart](https://tart.run/) - macOS virtualization
- [Vagrant](https://www.vagrantup.com/) - VM management
- [vagrant-tart plugin](https://github.com/letiemble/vagrant-tart)

## Commands

### VM Lifecycle (via tatin.sh script in scripts/)
```bash
tatin up        # Start the VM
tatin down      # Stop the VM
tatin delete    # Delete the VM
tatin status    # Check VM status
```

### Vagrant Direct Commands
```bash
vagrant up              # Start VM
vagrant halt            # Stop VM
vagrant destroy -f      # Delete VM
vagrant status          # Check status
vagrant ssh             # Connect to running VM
vagrant provision       # Re-run provisioning
```

## Architecture

- `Vagrantfile` - Main configuration for VM provisioning (Ruby/Vagrant DSL)
- `scripts/tatin.sh` - Lifecycle management wrapper with spinner and logging

## Documentation Resources

- [Tart docs](https://tart.dev/docs) and [FAQ](https://tart.run/faq/)
- [vagrant-tart configuration](https://letiemble.github.io/vagrant-tart/configuration.html)
- [Vagrant docs](https://developer.hashicorp.com/vagrant/docs)
- [Vagrantfile reference](https://developer.hashicorp.com/vagrant/docs/vagrantfile)

## Agent Conventions

Read AGENTS.md for full session workflow, but key points:

- **Visual output**: Use small Unicode symbols (`○ ◐ ● ✓ ❄`) with semantic colors, never emoji-style icons
- **Memory**: Use Beads (`bd` tool) for issue tracking; update MEMORY.md for long-term context
- **Session end**: Always complete with `git pull --rebase && bd sync && git push` - work is NOT done until pushed
- **Safety**: Use `trash` over `rm`; ask before destructive commands
- **Interactive editors**: Never use `bd edit` - use `bd update` with flags instead
