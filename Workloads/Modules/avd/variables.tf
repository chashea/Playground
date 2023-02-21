// Create variables
variable "workload" {
  description = "Workload name"
  type        = string
}
variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "resource_location" {
  description = "Resource location"
  type        = string
}
variable "resource_tags" {
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

