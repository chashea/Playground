// Create Variables for Location 
variable "location" {
  description = "Resource location"
  type        = string
}

// Create Variables for Tags
variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

// Create Variables for Environment
variable "environment" {
  description = "Environment name"
  type        = string
}

// Create Variables for Prefix

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

// Create Variables for VNet Name
variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}

// Create Variables for FW Subnet Address Prefixes
variable "fw_subnet" {
  description = "Firewall Subnet Address Prefixes"
  type        = list(string)
}

