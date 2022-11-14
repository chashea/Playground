resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet
  address_prefixes     = ["10.0.0.64/26"]
}

resource "azurerm_public_ip" "pip_fw" {
  name                = "pip-fw"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  tags                = var.resource_tags
}

resource "azurerm_firewall" "azfw" {
  name                = var.fw_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  firewall_policy_id  = var.fw_policy_id
}