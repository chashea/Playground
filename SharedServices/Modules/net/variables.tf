// Create a Variable for Location
variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

// Create a Variable for Environment
variable "environment" {
  type        = string
  description = "The environment dev / test / prod"
}

// Create a Variable for Tags
variable "tags" {
  type        = map(string)
  description = "The base tags for all the resources"
}

// Create a Variable for Virtual Network Address Space
variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

// Create a Variable for Subnet Address Prefixes
variable "subnet_address_prefixes" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}

// Create a variable for Bastion Subnet Address Prefixes
variable "bastion_subnet" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}