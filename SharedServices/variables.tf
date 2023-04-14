// Create Variables fo Location, Environment, Prefix and Tags
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
variable "prefix" {
  type        = string
  description = "The prefix for all resources in this example"
}

// Create Variables for Hub Virtual Network, Subnet, and Firewallv
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
variable "fw_subnet" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}