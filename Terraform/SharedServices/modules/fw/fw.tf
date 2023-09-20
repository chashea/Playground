locals {
  fw_name     = "fw-hub-${var.prefix}-${var.environment}-${var.location}"
  pip_fw_name = "pip-fw-${var.prefix}-${var.environment}-${var.location}"
  rg_name     = "rg-hub-fw-${var.prefix}-${var.environment}-${var.location}"
}

// Create a Resource Group for Azure Firewall
resource "azurerm_resource_group" "rg_fw" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

// Create a Public IP for Azure Firewall
resource "azurerm_public_ip" "pip_fw" {
  name                = local.pip_fw_name
  resource_group_name = local.rg_name
  location            = azurerm_resource_group.rg_fw.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = azurerm_resource_group.rg_fw.tags
}

// Create Subnet for Azure Firewall
resource "azurerm_subnet" "subnet_fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_name
  address_prefixes     = var.fw_subnet
}

// Create the Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = local.fw_name
  location            = azurerm_resource_group.rg_fw.location
  resource_group_name = local.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_fw.id
    public_ip_address_id = azurerm_public_ip.pip_fw.id
  }
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  tags               = azurerm_resource_group.rg_fw.tags
}