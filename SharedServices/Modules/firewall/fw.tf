// Create Local for Firewall and Public IP
locals {
  fw_name     = "fw-${var.environment}-${var.location}"
  fw_pip_name = "fw-pip-${var.environment}-${var.location}"
}

// Create Subnet for Azure Firewall
resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = locals.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.fw_subnet
  tags                 = azurerm_resource_group.rg.tags
  depends_on = [
    azurerm_resource_group.rg
  ]
}

// Create a Public IP for Azure Firewall
resource "azurerm_public_ip" "azfwpip" {
  name                = locals.fw_pip_name
  resource_group_name = locals.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = azurerm_resource_group.rg.tags
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_subnet.fw_subnet
  ]
}

// Create the Azure Firewall
resource "azurerm_firewall" "azfw" {
  name                = locals.fw_name
  location            = var.location
  resource_group_name = locals.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.azfwpip.id
  }
  firewall_policy_id = var.fw_policy_id
  tags               = azurerm_resource_group.rg.tags
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_subnet.fw_subnet,
    azurerm_public_ip.azfwpip
  ]
}