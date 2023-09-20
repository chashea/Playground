// Variables for Resources
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

variable "rg_hub" {
  description = "Resource Group name"
  type        = string
}

variable "hub_vnet_name" {
  description = "Hub VNet name"
  type        = string
}

