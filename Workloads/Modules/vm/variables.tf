// Variables for VM Module

variable "location" {
  description = "Resource location"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "key_vault_key_id" {
  description = "The Key Vault Key ID which should be used for Disk Encryption"
  type        = string
}

variable "user_assigned_identity_id" {
  description = "The User Assigned Identity ID which should be used for Disk Encryption"
  type        = string
}

variable "disk_encryption_set_id" {
  description = "The Disk Encryption Set ID which should be used for Disk Encryption"
  type        = string
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
}

variable "subnet_id" {
  description = "The Subnet ID which should be used for the VM"
  type        = string
}

