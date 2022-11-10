variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "The resource group location"
}

variable "fw_policy_id" {
  type        = string
  description = "The firewall policy id"
}
variable "vnet" {
  type        = string
  description = "The virtual network name"
}

variable "fw_name" {
  type        = string
  description = "The firewall name"
}