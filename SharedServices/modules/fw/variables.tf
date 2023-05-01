// Create Variables for Location, Environment, Prefix, and Tags
variable "location" {
  description = "Resource location"
  type        = string
}
variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}
variable "fw_subnet" {
  description = "Hub Firewall Subnet address prefix"
  type        = list(string)
}
variable "hub_vnet_name" {
  description = "Hub VNet name"
  type        = string
}
variable "fw_subnet_id" {
  description = "fw subnet id"
  type        = string
}
