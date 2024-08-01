module "kv" {
  source                   = "Azure/avm-res-keyvault-vault/azurerm"
  version                  = "0.3.0"
  name                     = module.naming.key_vault.name_unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku_name                 = "standard"
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = true
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zone.resource.id]
      subnet_resource_id            = module.hub_vnet.subnets["subnet3"].resource.id
    }
  }
  tags = {
    deployment = "terraform"
  }
}



