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

// Create Variables for FW Subnet and Virtual Network
variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}

// Create Variables for FW Subnet Address Prefixes
variable "fw_subnet" {
  description = "Firewall Subnet Address Prefixes"
  type        = list(string)
}

