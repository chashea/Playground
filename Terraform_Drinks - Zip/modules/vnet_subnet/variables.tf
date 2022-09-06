variable "name" {
  description = "The name for subnet"
}

variable "virtual_network_name" {
  description = "The name for the virtual network"
}

variable "subnet_address_prefix" {
  description = "The name for the virtual network"
  type        = list(string)
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
}