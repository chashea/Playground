variable "location" {
  type = string
  description = "Azure region resource will be built in"
}

variable "virtual_network_name" {
  description = "The name for the virtual network"
}

variable "virtual_network_address_space" {
  description = "The name for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "The name and address prefix for the subnet"
  type        = map(object({
      name = string
      address_prefix = list(string)
    }))
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
}

variable "tags" {
  description = "The tags for the Azure resource"
  type        = map(string)
}