module "storage" {
  source              = "Azure/avm-res-storage-storageaccount/azurerm"
  version             = "0.2.1"
  name                = module.naming.storage_account.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zone.resource.id]
      subnet_resource_id            = module.spoke_vnet.subnets["subnet1"].id
      subresource_name              = "blob"
    }
  }
}

