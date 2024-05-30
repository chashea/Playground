data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-eus2-001"
  location = "eastus2"
}


module "hub_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = ">=0.1.0"
  enable_telemetry    = var.enable_telemetry
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

