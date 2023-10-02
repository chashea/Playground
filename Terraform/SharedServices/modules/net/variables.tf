// Create Variables for Location, Environment, Prefix, and Tags
variable "location" {
  description = "Resource location"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
// Create Variables for Hub Virtual Network and Subnet
variable "vnet_address_space" {
  description = "Hub VNet address space"
  type        = list(string)
}
variable "subnet_address_prefixes" {
  description = "Hub Subnet address prefixes"
  type        = list(string)
}