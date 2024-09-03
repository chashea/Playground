resource "azurerm_resource_group" "rg_vault" {
  name     = "${module.naming.resource_group.name_unique}-vault"
  location = "eastus2"
}

// Deploy Private DNS Zone
module "privatednszone_kv" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "0.1.2"
  resource_group_name = azurerm_resource_group.rg_law.name
  domain_name         = "privatelink.vaultcore.azure.net"
  virtual_network_links = {
    vnetlink0 = {
      vnetlinkname = "dnslinktovnet002"
      vnetid       = module.hub_vnet.resource.id
    }
  }
  tags = {
    deployment = "terraform"
  }
}


module "kv" {
  source                        = "Azure/avm-res-keyvault-vault/azurerm"
  version                       = "0.3.0"
  name                          = module.naming.key_vault.name_unique
  resource_group_name           = azurerm_resource_group.rg_vault.name
  location                      = azurerm_resource_group.rg_vault.location
  sku_name                      = "standard"
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = false
  private_endpoints = {
    primary = {
      name                          = module.naming.private_endpoint.name_unique
      subnet_resource_id            = module.hub_vnet.subnets["subnet3"].resource.id
      private_dns_zone_resource_ids = [module.privatednszone_kv.resource.id]
    }
  }
  tags = {
    deployment = "terraform"
  }
}


