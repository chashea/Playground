variable "location" {
  type        = string
  description = "The resource group location"
}
variable "tags" {
  type        = map(string)
  description = "The resource tags"
}
variable "fw_policy_id" {
  type        = string
  description = "The firewall policy id"
}

variable "vnet_name" {
  type        = string
  description = "The virtual network name"
}

variable "fw_subnet" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}

variable "environment" {
  type        = string
  description = "The environment dev / test / prod"
}
