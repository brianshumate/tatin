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

  # Base system packages (build dependencies for mise-compiled languages)
  provisioner "shell" {
    script = "${path.root}/scripts/base-system.sh"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  # Bun: Install bun using curlbash from bun.sh (official method)
  provisioner "shell" {
    script          = "${path.root}/scripts/bun.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.ssh_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.ssh_username}"
    ]
  }

  # Write mise README with installation instructions
  provisioner "file" {
    content     = file("files/mise-readme.md")
    destination = "/home/${var.ssh_username}/MISE_README.md"
  }

  # Copy README.md to admin home directory
  provisioner "file" {
    content     = file("files/README.md")
    destination = "/home/${var.ssh_username}/README.md"
  }

  # Copy mise.toml to admin home directory
  provisioner "file" {
    content     = file("files/mise.toml")
    destination = "/home/${var.ssh_username}/mise.toml"
  }

  # Agent tools: Claude Code + OpenCode (parallel installation)
  # These only depend on curl (installed by base-system.sh) and can run in parallel internally
  provisioner "shell" {
    script          = "${path.root}/scripts/agent-tools.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.ssh_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.ssh_username}"
    ]
  }

  # Bun-based tools: Pi + Crush + qmd (parallel installation)
  # These depend on officially installed bun and can run in parallel internally
  provisioner "shell" {
    script          = "${path.root}/scripts/bun-tools.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E -u ${var.ssh_username} bash '{{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HOME=/home/${var.ssh_username}"
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
