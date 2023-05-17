// Create Variable for Environment
variable "environment" {
  description = "Environment name"
  type        = string
}

// Create Variable for Location
variable "location" {
  description = "Resource location"
  type        = string
}

// Create Variable for Tags
variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

// Create Variable for Address Prefixes 
variable "bastion_subnet" {
  description = "Hub VNet address space"
  type        = list(string)
}

// Create Variable for Virtual Network
variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}


