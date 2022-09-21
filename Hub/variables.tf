## Hub
variable "rg_name" {
  default = "Rg-Hub-WUS"
}

variable "rg_location" {
  default = "westus"
}

# Virtual Network
variable "hubvnet_name" {
  default = "Vnet-Hub-WUS"
}

variable "bastion_sub" {
  default = "AzureBastionSubnet"
}

variable "fw_sub" {
  default = "AzureFirewallSubnet"
}

variable "adds_sub" {
  default = "ADDS-Subnet"
}

variable "bastion_name" {
  default = "Bastion-WUS"
}

variable "fw_name" {
  default = "Fw-WUS"
}

variable "fw_policy_name" {
  default = "FW-Policy-WUS"
}

variable "fw_rule_collection_group" {
  default = "FW-RuleCollection-WUS"
}

variable "fw_net_rule" {
  default = "FW-NetRule-WUS"

}
