locals {
  resource_group_name = "rg-vvwan-eus2-001"
  location            = "eastus2"
}

module "vwan" {
  source                         = "Azure/avm-ptn-virtualwan/azurerm"
  version                        = "0.4.2"
  location                       = local.location
  create_resource_group          = true
  resource_group_name            = local.resource_group_name
  allow_branch_to_branch_traffic = true
  virtual_wan_name               = "vwan-eus2-001"
  virtual_hubs = {
    hub1 = {
      name           = "vhub-eus2-001"
      address_prefix = "10.1.0.0/16"
      resource_group = local.resource_group_name
      location       = local.location
    }
  }
}

module "azfw" {
  source              = "Azure/avm-res-network-azurefirewall/azurerm"
  version             = ">=0.1.0"
  resource_group_name = local.resource_group_name
  location            = local.location
  name                = "azfw-eus2-001"
  firewall_sku_name   = "AZFW_Hub"
  firewall_sku_tier   = "Premium"
  firewall_virtual_hub = {
    virtual_hub_id  = module.vwan.virtual_hub_id[0]
    public_ip_count = 3
  }
  firewall_zones     = ["1", "2", "3"]
  firewall_policy_id = module.fwpolicy.resource.id
}

module "fwpolicy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"
  version             = ">=0.1.0"
  resource_group_name = local.resource_group_name
  location            = local.location
  name                = "fwpolicy-eus2-001"
  firewall_policy_dns = {
    proxy_enabled = true
  }
  firewall_policy_sku = "Premium"
  firewall_policy_threat_intelligence_mode = "Alert"

}