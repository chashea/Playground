// Create Variables for Location, Environment, Prefix, and Tags
variable "location" {
  default     = "eastus"
  description = "Resource location"
  type        = string
}
variable "tags" {
  default = {
    environment = "dev"
    costcenter  = "1234556677"
    owner       = "cloud team"
    workload    = "azure firewall"
  }
  description = "Resource tags"
  type        = map(string)
}
variable "environment" {
  default     = "dev"
  description = "Environment name"
  type        = string
}
variable "prefix" {
  default     = "azfw"
  description = "Prefix for all resources"
  type        = string
}

// Create Variables for FW Subnet and Virtual Network
variable "vnet_address_space" {
  default     = ["10.10.0.0/24"]
  description = "Hub VNet address space"
  type        = list(string)
}
variable "azfw_subnet" {
  default     = ["10.10.0.0/26"]
  description = "Firewall Subnet Address Prefixes"
  type        = list(string)
}

// Create Variables for IP Groups
variable "workloadiPCIDR" {
  default     = ["10.20.0.0/24", "10.30.0.0/24"]
  description = "Workload IP CIDR"
  type        = list(string)
}
variable "infraIPCIDR" {
  default     = ["10.40.0.0/24", "10.50.0.0/24"]
  description = "Workload IP Name"
  type        = list(string)
}

// Create Variables for Azure Firewall
variable "azfw_sku_name" {
  default     = "AZFW_VNet"
  description = "Azure Firewall SKU Name"
  type        = string
}
variable "azfw_sku_tier" {
  default     = "Premium"
  description = "Azure Firewall SKU Tier"
  type        = string
}