# Tatin: LLM agent sandbox
#
# Packer template for building Tart VM image with languages and LLM agent tools
#
# User setup:
# - 'admin' user for initial SSH and base-system provisioning
# - 'agent' user with sudo capabilities for runtime and all tool installation
# - Vagrant uses 'agent' user for SSH after image build

packer {
  required_plugins {
    tart = {
      version = ">= 1.12.0"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

source "tart-cli" "tatin" {
  vm_base_name   = var.base_image
  vm_name        = var.vm_name
  cpu_count      = var.cpu_count
  memory_gb      = var.memory_gb
  disk_size_gb   = var.disk_size_gb
  headless       = true
  ssh_username   = var.ssh_username
  ssh_password   = var.ssh_password
  ssh_timeout    = "20s"
}

build {
  sources = ["source.tart-cli.tatin"]

  # Base system packages
  provisioner "shell" {
    script = "${path.root}/scripts/base-system.sh"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  # Create agent user with sudo capabilities
  provisioner "shell" {
    script = "${path.root}/scripts/create-agent-user.sh"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "AGENT_USERNAME=${var.agent_username}",
      "AGENT_PASSWORD=${var.agent_password}"
    ]
  }

  # Upload .bashrc first - it must be in place before any user scripts run
  provisioner "file" {
    content     = file("files/.bashrc")
    destination = "/tmp/.bashrc"
  }

  # Move .bashrc to agent home so it's available for all agent user scripts
  provisioner "shell" {
    inline = [
      "sudo mv /tmp/.bashrc /home/${var.agent_username}/.bashrc",
      "sudo chown ${var.agent_username}:${var.agent_username} /home/${var.agent_username}/.bashrc",
      "sudo chmod 644 /home/${var.agent_username}/.bashrc"
    ]
  }

  # Upload files to /tmp, then move to agent home
  provisioner "file" {
    content     = file("files/MISE_README.md")
    destination = "/tmp/MISE_README.md"
  }

  provisioner "file" {
    content     = file("files/README.md")
    destination = "/tmp/README.md"
  }

  provisioner "file" {
    content     = file("files/mise.toml")
    destination = "/tmp/mise.toml"
  }

  # Fix permissions on uploaded files so agent user can read them
  provisioner "shell" {
    inline = [
      "chmod 644 /tmp/mise.toml /tmp/MISE_README.md /tmp/README.md"
    ]
  }

  # mise: Install mise, then use it to install languages and tools
  provisioner "shell" {
    script          = "${path.root}/scripts/mise.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.agent_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.agent_username}"
    ]
  }

  # Move remaining files from /tmp to agent home with correct ownership
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /home/${var.agent_username}/work",
      "sudo mv /tmp/MISE_README.md /home/${var.agent_username}/MISE_README.md",
      "sudo mv /tmp/README.md /home/${var.agent_username}/README.md",
      "sudo mv /tmp/mise.toml /home/${var.agent_username}/work/mise.toml",
      "sudo chown -R ${var.agent_username}:${var.agent_username} /home/${var.agent_username}/work",
      "sudo chown ${var.agent_username}:${var.agent_username} /home/${var.agent_username}/MISE_README.md",
      "sudo chown ${var.agent_username}:${var.agent_username} /home/${var.agent_username}/README.md",
      "sudo -u ${var.agent_username} mise trust /home/${var.agent_username}/work/mise.toml"
    ]
  }

  # Set message of the day from README.md
  provisioner "shell" {
    inline = [
      "sudo cp /home/${var.agent_username}/README.md /etc/motd",
      "sudo chmod 644 /etc/motd"
    ]
  }

  # Agent tools: Claude Code + OpenCode
  # These depend on just curl and can install in parallel internally
  provisioner "shell" {
    script          = "${path.root}/scripts/agent-tools.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.agent_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.agent_username}"
    ]
  }

  # Bun-based tools: Pi + Crush + qmd
  # These depend on bun and can install in parallel internally
  provisioner "shell" {
    script          = "${path.root}/scripts/bun-tools.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.agent_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.agent_username}"
    ]
  }

  # Final cleanup and configuration
  provisioner "shell" {
    script          = "${path.root}/scripts/finalize.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.agent_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.agent_username}"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
