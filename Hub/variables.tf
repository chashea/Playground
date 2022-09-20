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

