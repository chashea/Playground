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

variable "hubvnet_address_space" {
  default = "10.15.0.0/24"
}

variable "fw_subnet_name" {
  default = "AzureFirewallSubnet"
}

variable "fw_address_prefix" {
  default = "10.15.0.0/26"
}

variable "bastion_subnet_name" {
  default = "AzureBastionSubnet"
}

variable "bastion_address-prefix" {
  default = "10.15.0.64/26"
}

variable "mgmt_subnet_name" {
  default = "mgmt-subnet"
}

variable "mgmt_address_prefix" {
  default = "10.15.0.128/27"
}

