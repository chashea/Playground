data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-eus2-001"
  location = "eastus2"
}


module "hub_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = ">=0.1.0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "vnet-hub-eus2-001"
  address_space       = ["10.200.0.0/16"]
}

resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.hub_vnet.resource.name
  address_prefixes     = ["10.200.0.0/26"]
}

module "avd_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = ">=0.1.0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "vnet-avd-eus2-001"
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "avd_subnet" {
  name                 = "avd-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.avd_vnet.resource.name
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_route_table" "rt_avd" {
  name                = "rt-avd"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  route {
    name                   = "route-avd"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.200.0.4"
  }
}

resource "azurerm_subnet_route_table_association" "avd" {
  subnet_id      = azurerm_subnet.avd_subnet.id
  route_table_id = azurerm_route_table.rt_avd.id
}

resource "azurerm_virtual_network_peering" "hub_to_avd" {
  name                         = "hub-to-avd"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = module.hub_vnet.resource.name
  remote_virtual_network_id    = module.avd_vnet.resource.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "avd_to_hub" {
  name                         = "avd-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = module.avd_vnet.resource.name
  remote_virtual_network_id    = module.hub_vnet.resource.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

