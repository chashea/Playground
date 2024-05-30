module "avd_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = ">=0.1.0"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "vnet-avd-eus2-001"
  address_space       = ["10.100.0.0/16"]
}

