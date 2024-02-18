# This is required for resource modules
resource "azurerm_resource_group" "rg" {
  name     = "rg-fw-terraform"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-fw-terraform"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/26"]
}

module "avm-res-network-publicipaddress" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"
  # insert the 3 required variables here
  name                = "pip-fw-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    deployment = "terraform"
  }
  zones = ["1", "2", "3"]
}

# This is the module call
module "avm-res-network-azurefirewall" {
  source  = "Azure/avm-res-network-azurefirewall/azurerm"
  version = "0.1.1"
  # source             = "Azure/avm-res-network-firewall/azurerm"
  name                = "fw-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  firewall_sku_tier   = "Standard"
  firewall_sku_name   = "AZFW_VNet"
  firewall_zones      = ["1", "2", "3"]
  firewall_ip_configuration = [
    {
      name                 = "ipconfig1"
      subnet_id            = azurerm_subnet.subnet.id
      public_ip_address_id = module.avm-res-network-publicipaddress.public_ip_id
    }
  ]
  firewall_policy_id = module.avm-res-network-firewallpolicy.name.id
  tags = {
    deployment = "terraform"
  }
}

module "avm-res-network-firewallpolicy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"
  version             = "0.1.0"
  name                = "fw-policy-terraform"
  firewall_policy_sku = "Standard"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags = {
    deployment = "terraform"
  }
}



