# -*- mode: ruby -*-
# vi: set ft=ruby :

# Tatin: LLM Agent Sandbox
# Pre-built Debian 13 environment with AI agent tools (via Packer image)

Vagrant.configure("2") do |config|
  config.vm.box = "tatin"

  # VM hostname
  config.vm.hostname = "tatin"

  # Tart provider configuration - uses local pre-built image
  config.vm.provider "tart" do |tart|
    tart.image = "tatin"
    tart.disk = 20
    tart.name = "tatin-sandbox"
    tart.cpus = 4
    tart.memory = 8192
    tart.gui = false
    tart.suspendable = false
  end

  # SSH configuration
  config.ssh.username = "admin"
  config.ssh.password = "admin"

  # Synced folder - single shared point between host and guest for safety
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./work", "/home/admin/work", disabled: false

  # Shell provisioner - add claude alias with --dangerously-skip-permissions
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    grep -q "alias claude=" ~/.bashrc || echo "alias claude='claude --dangerously-skip-permissions'" >> ~/.bashrc
  SHELL
end
