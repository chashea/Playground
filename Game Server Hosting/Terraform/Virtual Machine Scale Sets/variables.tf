variable "resource_location" {
  type        = string
  description = "The resource location, typically matches resource group location"
}

variable "resource_tags" {
  type        = map(string)
  description = "The base tags for all the resources"
}

variable "hub_vnet_name" {
  type = string
  description = "The hub vnet name"
}

variable "spoke_vnet_name" {
  type = string
  description = "The hub vnet name"
}

variable "subnet_range" {
  type = list(string)
  description = "The subnet range"
}

variable "hub_subscription_id" {
  type = string
  description = "The hub subscription id"
}

variable "spoke_subscription_id" {
  type = string
  description = "The spoke subscription id"
}

