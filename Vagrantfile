# -*- mode: ruby -*-
# vi: set ft=ruby :

# Tatin: LLM Agent Sandbox
# Pre-built Debian 13 environment with AI agent tools (via Packer image)

# Environment variable overrides for VM resources
# Can be set before running vagrant commands:
#   export TATIN_CPUS=8
#   export TATIN_MEMORY=16384
#   export TATIN_DISK=50

TATIN_CPUS = ENV.fetch('TATIN_CPUS', 4).to_i
TATIN_MEMORY = ENV.fetch('TATIN_MEMORY', 8192).to_i
TATIN_DISK = ENV.fetch('TATIN_DISK', 20).to_i

Vagrant.configure("2") do |config|
  config.vm.box = "tatin"

  # VM hostname
  config.vm.hostname = "tatin"

  # Tart provider configuration - uses local pre-built image
  config.vm.provider "tart" do |tart|
    tart.image = "tatin"
    tart.disk = TATIN_DISK
    tart.name = "tatin-sandbox"
    tart.cpus = TATIN_CPUS
    tart.memory = TATIN_MEMORY
    tart.gui = false
    tart.suspendable = false
  end

  # SSH configuration
  config.ssh.username = "admin"
  config.ssh.password = "admin"

  # Synced folder - single shared point between host and guest for safety
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./work", "/home/admin/work", disabled: false
end
