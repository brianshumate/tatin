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
  description = "SSH username for provisioning"
}

variable "ssh_password" {
  type        = string
  default     = "admin"
  sensitive   = true
  description = "SSH password for provisioning"
}

variable "go_version" {
  type        = string
  default     = "1.23.5"
  description = "Go version to install"
}
