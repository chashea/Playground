variable "location" {
  type = string
  description = "Azure region resource will be built in"
}

variable "virtual_network_name" {
  description = "The name for the virtual network"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
}

variable "tags" {
  description = "The tags for the Azure resource"
  type        = map(string)
}

variable "subnet_name" {
  description = "The name and address prefix for the subnet"
}

variable "vmname" {
  description = "Virtual Machine Name"
}