data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-hub-eus2-001"
  location = "eastus2"
}


module "hub_vnet" {
  source                        = "Azure/avm-res-network-virtualnetwork/azurerm"
  version                       = ">=0.1.0"
  enable_telemetry              = var.enable_telemetry
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  name                          = "vnet-hub-eus2-001"
  virtual_network_address_space = ["10.200.0.0/16"]
  subnets = {
    AzureFirewallSubnet = {
      address_prefixes = ["10.200.0.0/26"]
    }
    AzureBastionSubnet = {
      address_prefixes = ["10.200.0.64/26"]
    }
    subnet = {
      address_prefixes = ["10.200.1.0/24"]
    }
  }
}

module "fw_public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = ">=0.1.0"
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


module "azfw" {
  source              = "Azure/avm-res-network-azurefirewall/azurerm"
  version             = ">=0.1.0"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "azfw-eus2-001"
  firewall_sku_name   = "AZFW_VNet"
  firewall_sku_tier   = "Premium"
  firewall_zones      = ["1", "2", "3"]
  firewall_policy_id  = module.fwpolicy.resource.id
  firewall_ip_configuration = [
    {
    name                 = "ipconfig_fw"
    subnet_id            = module.hub_vnet.subnets.AzureFirewallSubnet.id
    public_ip_address_id = module.fw_public_ip.public_ip_id
    }
  ]
}

module "fwpolicy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"
  version             = ">=0.1.0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "fwpolicy-eus2-001"
  firewall_policy_dns = {
    proxy_enabled = true
  }
  firewall_policy_sku                      = "Premium"
  firewall_policy_threat_intelligence_mode = "Alert"
}