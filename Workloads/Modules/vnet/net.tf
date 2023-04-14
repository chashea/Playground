// Create a Resource Group for the Virtual Network and Subnet
resource "azurerm_resource_group" "rg_net" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

// Create a Virtual Network with a single subnet
resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "vnet-${var.location}-${var.environment}"
  address_space       = ["10.11.0.0/20"]
  location            = var.location
  resource_group_name = local.rg_name
  tags                = var.tags
}
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.location}-${var.environment}"
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_name
  address_prefixes     = ["10.11.0.0/26"]
}

// Create two Virtual Network Peerings
resource "azurerm_virtual_network_peering" "vnet_peering" {
  name                         = local.vnet_peering_name_1
  resource_group_name          = local.rg_name
  virtual_network_name         = local.vnet_name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "vnet_peering_2" {
  name                         = local.vnet_peering_name_2
  resource_group_name          = var.rg_hub
  virtual_network_name         = data.azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}