// Create Variables for Hub Network

variable "rg_hub_name" {
  type        = string
  description = "value of the resource group name for hub network"
}

variable "location" {
  type        = string
  description = "value of the location for hub network"
}

// Create VNet Variables for Hub Network

variable "hub_vnet_name" {
  type        = string
  description = "value of the hub virtual network name"
}

variable "hub_vnet_address" {
  type        = list(string)
  description = "value of the hub virtual network address space"
}

// Create Variables for Firewall Subnet

variable "fw_subnet_address" {
  type        = list(string)
  description = "value of the firewall subnet address space"
}

// Create Variables for Bastion Subnet

variable "bastion_subnet_address" {
  type        = list(string)
  description = "value of the bastion subnet address space"
}

// Create Variables for Route Server Subnet

variable "route_server_subnet_address" {
  type        = list(string)
  description = "value of the route server subnet address space"
}

// Create Variables for Azure Firewall

variable "fw_pip_name" {
  type        = string
  description = "value of the FW public IP address name"
}

variable "fw_name" {
  type        = string
  description = "value of the FW name"
}

variable "fw_sku_tier" {
  type        = string
  description = "value of the FW SKU tier"
}

variable "fw_sku_name" {
  type        = string
  description = "value of the FW SKU name"
}

variable "fw_ip_config_name" {
  type        = string
  description = "value of the FW IP configuration name"
}

// Create Variables for Bastion

variable "bastion_pip_name" {
  type        = string
  description = "value of the bastion public IP address"
}
variable "bastion_name" {
  type        = string
  description = "value of the bastion name"
}

variable "bastion_ip_config_name" {
  type        = string
  description = "value of the bastion IP configuration name"
}

// Create Variables for Route Server

variable "route_server_pip_name" {
  type        = string
  description = "value of the route server public IP address"
}

variable "route_server_name" {
  type        = string
  description = "value of the route server name"
}

variable "route_server_ip_config_name" {
  type        = string
  description = "value of the route server IP configuration name"
}

variable "route_server_branch_to_branch" {
  type        = bool
  description = "value of the route server branch to branch traffic"
}

variable "route_server_bgp_connection_name" {
  type        = string
  description = "value of the route server BGP connection name"
}

variable "peer_asn" {
  type        = number
  description = "value of the peer ASN"
}

variable "peer_ip" {
  type        = string
  description = "value of the peer IP address"
}

// Create Variables for Azure Firewall Parent Policy

variable "fw_parent_policy_name" {
  type        = string
  description = "value of the FW parent policy name"
}

