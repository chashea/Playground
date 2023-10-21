// Create a Resource Group for Hub Network
resource "azurerm_resource_group" "rg" {
  name     = var.rg_hub_name
  location = var.location
}

// Create a Virtual Network for Hub Network

resource "azurerm_virtual_network" "vnet" {
  name                = var.hub_vnet_name
  address_space       = var.hub_vnet_address
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

// Create a Subnet for Azure Firewall

resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.fw_subnet_address
}

// Create a Subnet for Bastion

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_subnet_address
}

// Create a Subnet for Route Server

resource "azurerm_subnet" "route_server_subnet" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.route_server_subnet_address
}


