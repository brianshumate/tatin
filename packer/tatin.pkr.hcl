# Tatin: LLM Agent Sandbox
# Packer template for building Tart VM image with pre-installed development tools

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
  ssh_timeout    = "120s"
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

  # Python 3
  provisioner "shell" {
    script = "${path.root}/scripts/python.sh"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  # Go
  provisioner "shell" {
    script = "${path.root}/scripts/golang.sh"
    environment_vars = [
      "GO_VERSION=${var.go_version}"
    ]
  }

  # Node.js LTS (needed before Bun for npm fallback)
  provisioner "shell" {
    script = "${path.root}/scripts/nodejs.sh"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  # Bun (user-space install)
  provisioner "shell" {
    script          = "${path.root}/scripts/bun.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.ssh_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.ssh_username}"
    ]
  }

  # Claude Code (user-space install)
  provisioner "shell" {
    script          = "${path.root}/scripts/claude-code.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.ssh_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.ssh_username}"
    ]
  }

  # OpenCode (user-space install)
  provisioner "shell" {
    script          = "${path.root}/scripts/opencode.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.ssh_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.ssh_username}"
    ]
  }

  # Crush (user-space install via npm)
  provisioner "shell" {
    script          = "${path.root}/scripts/crush.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.ssh_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.ssh_username}",
      "PATH=/home/${var.ssh_username}/.bun/bin:/usr/local/go/bin:/usr/bin:/bin"
    ]
  }

  # Final cleanup and configuration
  provisioner "shell" {
    script = "${path.root}/scripts/finalize.sh"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "SSH_USERNAME=${var.ssh_username}"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
