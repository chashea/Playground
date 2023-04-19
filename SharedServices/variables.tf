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

// Create Variables for Hub Virtual Network, Subnet, and Bastion
variable "vnet_address_space" {
  description = "Hub VNet address space"
  type        = list(string)
}
variable "subnet_address_prefixes" {
  description = "Hub Subnet address prefixes"
  type        = list(string)
}
variable "bastion_subnet" {
  description = "Hub Bastion Subnet address prefix"
  type        = list(string)
}

// Create Variables for Firewall
variable "fw_subnet" {
  description = "Hub Firewall Subnet address prefix"
  type        = list(string)
}