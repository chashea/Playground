data "azurerm_client_config" "current" {}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
}

resource "azurerm_resource_group" "rg_hub" {
  name     = "${module.naming.resource_group.name_unique}-hub"
  location = "eastus2"
}

module "hub_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.0"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = azurerm_resource_group.rg_hub.location
  name                = "${module.naming.virtual_network.name_unique}-hub"
  address_space       = ["10.200.0.0/16"]
  subnets = {
    subnet0 = {
      name           = "AzureFirewallSubnet"
      address_prefix = "10.200.0.0/26"
    }
    subnet1 = {
      name           = "AzureBastionSubnet"
      address_prefix = "10.200.0.64/26"
    }
    subnet2 = {
      name           = "GatewaySubnet"
      address_prefix = "10.200.1.0/27"
    }
    subnet3 = {
      name           = "pe-${module.naming.subnet.name_unique}"
      address_prefix = "10.200.2.0/24"
    }
    subnet4 = {
      name           = "adds-${module.naming.subnet.name_unique}"
      address_prefix = "10.200.0.128/28"
    }
  }
}


