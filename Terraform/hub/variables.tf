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

// Create Variables for Azure Firewall Parent Policy

variable "fw_parent_policy_name" {
  type        = string
  description = "value of the FW parent policy name"
}

// Create Variables for Virtual WAN

variable "vwan_name" {
  type        = string
  description = "value of the virtual WAN name"
}

// Create Variables for Virtual Hub

variable "vhub_name" {
  type        = string
  description = "value of the virtual hub name"
}

// Virtual Network Gateway

variable "vng_name" {
  type        = string
  description = "value of the virtual network gateway name"
}

variable "vng_sku" {
  type        = string
  description = "value of the virtual network gateway SKU"
}

variable "vng_ip_config_name" {
  type        = string
  description = "value of the virtual network gateway IP configuration name"
}

variable "vng_pip_name" {
  type        = string
  description = "value of the virtual network gateway public IP address name"
}

// Create Variables for Local Network Gateway

variable "lng_name" {
  type        = string
  description = "value of the local network gateway name"
}

variable "lng_address_space" {
  type        = list(string)
  description = "value of the local network gateway address space"
}