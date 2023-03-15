variable "location" {
  description = "Resource location"
  type        = string
}
variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
variable "vnet_address_space" {
  description = "Virtual Network Address Space"
  type        = list(string)
}
variable "subnet_address_prefix" {
  description = "Subnet Address Prefix"
  type        = list(string)
}
variable "environment" {
  description = "Environment name"
  type        = string
}


