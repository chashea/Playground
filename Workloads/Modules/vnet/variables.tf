// Create the Variables for Virtual Network and Subnet

variable "vnet_address_space" {
  type        = string
  description = "The address space that is used by the virtual network."
}
variable "subnet_address_space" {
  type        = string
  description = "The address space that is used by the subnet."
}

variable "location" {
  type        = string
  description = "The Azure Region where the resources should exist."
}
variable "tags" {
    type        = map(string)
    description = "A mapping of tags to assign to the resources."
}
variable "environment" {
  type        = string
  description = "The environment in which the resources should exist."
}

