# -*- mode: ruby -*-
# vi: set ft=ruby :

# Tatin: Large Language Model Agent Sandbox
# Pre-built Debian 13 environment with AI agent tools (via Packer image)
#
# This Vagrantfile uses the pre-built 'tatin' image where:
# - 'admin' user used during Packer provisioning
# - 'agent' user is the runtime user with password-less sudo

# Environment variable overrides for VM resources
# Can be set before running vagrant commands:
#   export TATIN_CPUS=8
#   export TATIN_MEMORY=16384
#   export TATIN_DISK=50

TATIN_CPUS = ENV.fetch('TATIN_CPUS', 4).to_i
TATIN_MEMORY = ENV.fetch('TATIN_MEMORY', 8192).to_i
TATIN_DISK = ENV.fetch('TATIN_DISK', 20).to_i

Vagrant.configure("2") do |config|
  config.vm.define 'tatin' do |machine|
    config.vm.box = 'tatin'
    config.vm.hostname = 'tatin'
    config.vm.provider 'tart' do |tart|
      tart.image = 'tatin'
      tart.disk = TATIN_DISK
      tart.name = 'tatin-sandbox'
      tart.cpus = TATIN_CPUS
      tart.memory = TATIN_MEMORY
      tart.gui = false
      tart.suspendable = false
    end
    config.ssh.username = 'agent'
    config.ssh.password = 'xmLGFhZqGlXvB2lJ/s+J8g='
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder(
      './work',
      '/home/agent/work',
      type: nil,
      mount_options: ['dmode=755', 'fmode=644'],
      rsync__exclude: ['.git/', 'node_modules/', '.cache/', '*.log']
    )
  end
end
