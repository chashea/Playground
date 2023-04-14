// Create the Variables for Virtual Network and Subnet
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
variable "hub_vnet_name" {
  type        = string
  description = "The name of the Hub Virtual Network."
}

variable "rg_hub" {
  type        = string
  description = "The name of the Resource Group."
}

