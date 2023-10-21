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

variable "hub_vnet_id" {
  type        = string
  description = "value of the hub VNet ID"
}

variable "hub_rg_name" {
  type        = string
  description = "value of the hub resource group name"
}

variable "hub_vnet_name" {
  type        = string
  description = "value of the hub virtual network name"
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