// Create Resource Group for Azure Virtual Desktop

resource "azurerm_resource_group" "rg" {
  name     = var.rg_avd_name
  location = var.avd_location
}

// Create Virtual Network for Azure Virtual Desktop

resource "azurerm_virtual_network" "vnet" {
  name                = var.avd_vnet_name
  address_space       = ["10.2.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

// Create Subnet for Azure Virtual Desktop

resource "azurerm_subnet" "pooled_subnet" {
  name                 = var.pooled_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.2.0.0/26"]
}

resource "azurerm_subnet" "personal_subnet" {
  name                 = var.personal_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.2.0.64/26"]
}


resource "azurerm_virtual_network_peering" "avd_hub_peering" {
  name                         = var.avd_vnet_peering
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_avd_peering" {
  name                         = var.vnet_avd_peering
  resource_group_name          = var.hub_rg_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

