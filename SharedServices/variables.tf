variable "location" {
  type        = string
  description = "The resource location, typically matches resource group location"
}
variable "environment" {
  type        = string
  description = "The environment dev / test / prod"
}
variable "tags" {
  type        = map(string)
  description = "The base tags for all the resources"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}
variable "subnet_address_prefixes" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}

variable "bastion_subnet" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}
