// Variables for Resources
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

// Variables for Virtual Network and Subnet
variable "vnet_address_space" {
  description = "Virtual Network Address Space"
  type        = list(string)
}
variable "subnet_address_space" {
  description = "Subnet Address Space"
  type        = list(string)
}

// Variables for VM
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

// Variables for Key Vault