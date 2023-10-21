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

// Create Variables for Azure Virtual Desktop

// Create Variables for AVD

variable "rg_avd_name" {
  type        = string
  description = "value of the resource group name for hub network"
}

variable "avd_location" {
  type        = string
  description = "value of the location for hub network"

}

// Create VNet Variables for AVD Network

variable "avd_vnet_name" {
  type        = string
  description = "value of the hub virtual network name"
}

// Create Variables for AVD VNet Peering

variable "avd_vnet_peering" {
  type        = string
  description = "value of the AVD VNet peering name"
}

variable "vnet_avd_peering" {
  type        = string
  description = "value of the hub VNet peering name"
}

// Create Variables for Pooled Subnet

variable "pooled_subnet_name" {
  type        = string
  description = "value of the AVD subnet name"
}

// Create Variables for Personal Subnet

variable "personal_subnet_name" {
  type        = string
  description = "value of the AVD subnet name"
}

// Create Variables for Pooled Host Pool

variable "pooled_name" {
  type        = string
  description = "value of the pooled host pool name"
}

variable "pooled_dag_name" {
  type        = string
  description = "value of the desktop app group name"
}

// Create Variables for Personal Host Pool

variable "personal_hostpool_name" {
  type        = string
  description = "value of the personal host pool name"
}

variable "personal_dag_name" {
  type        = string
  description = "value of the personal desktop app group name"
}

// Create Workspace Variables

variable "workspace_name" {
  type        = string
  description = "value of the workspace name"
}