// Create variable for Location
variable "location" {
  type        = string
  description = "The resource group location"
}

// Create variable for Tags
variable "tags" {
  type        = map(string)
  description = "The base tags for all the resources"
}

// Create variable for Environment
variable "environment" {
  type        = string
  description = "The environment dev / test / prod"
}

// Create variable for Virtual Network Name
variable "vnet_name" {
  type        = string
  description = "The name of the virtual network."
}

// Create a variable for Bastion Subnet Address Prefixes
variable "bastion_subnet" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}