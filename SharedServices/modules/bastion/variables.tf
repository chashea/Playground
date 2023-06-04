// Create Variables for Location, Environment, Prefix, and Tags
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
variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

// Create Variable for Bastion Subnet and Virtual Network
variable "bastion_subnet" {
  description = "Hub VNet address space"
  type        = list(string)
}
variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}


