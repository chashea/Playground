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

// Create Variables for Azure Firewall

variable "fw_pip_name" {
  type        = string
  description = "value of the FW public IP address name"
}

variable "fw_name" {
  type        = string
  description = "value of the FW name"
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

variable "route_server_bgp_connection_name" {
  type        = string
  description = "value of the route server BGP connection name"
}

// Create Variables for Azure Firewall Parent Policy

variable "fw_parent_policy_name" {
  type        = string
  description = "value of the FW parent policy name"
}

