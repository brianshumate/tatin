# Tatin Packer Variables
# Override these with -var or -var-file flags

variable "base_image" {
  type        = string
  default     = "ghcr.io/cirruslabs/debian:latest"
  description = "OCI image to use as base"
}

variable "vm_name" {
  type        = string
  default     = "tatin"
  description = "Name for the output VM"
}

variable "cpu_count" {
  type        = number
  default     = 4
  description = "Number of CPUs for the VM"
}

variable "memory_gb" {
  type        = number
  default     = 8
  description = "Memory in GB for the VM"
}

variable "disk_size_gb" {
  type        = number
  default     = 20
  description = "Disk size in GB for the VM"
}

variable "ssh_username" {
  type        = string
  default     = "admin"
  description = "SSH username for Packer provisioning only (base image default user)"
}

variable "ssh_password" {
  type        = string
  default     = "admin"
  sensitive   = true
  description = "SSH password for Packer provisioning only (base image default user)"
}

variable "agent_username" {
  type        = string
  default     = "agent"
  description = "Username for the runtime agent user (created during provisioning)"
}

variable "agent_password" {
  type        = string
  default     = "xmLGFhZqGlXvB2lJ/s+J8g="
  sensitive   = true
  description = "Password for the runtime agent user"
}
