resource "azurerm_resource_group" "rg" {
  name     = "rg-vwan-eus2-001"
  location = "eastus2"
}

resource "azurerm_virtual_wan" "vwan" {
  name                = "vwan-eus2-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  type                = "Standard"
}

resource "azurerm_virtual_hub" "vhub" {
  name                = "vhub-eus2-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.1.0.0/16"
}

module "azfw" {
  source              = "Azure/avm-res-network-azurefirewall/azurerm"
  version             = ">=0.1.0"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "azfw-eus2-001"
  firewall_sku_name   = "AZFW_Hub"
  firewall_sku_tier   = "Premium"
  firewall_virtual_hub = {
    virtual_hub_id  = azurerm_virtual_hub.vhub.id
    public_ip_count = 3
  }
  firewall_zones     = ["1", "2", "3"]
  firewall_policy_id = module.fwpolicy.resource.id
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