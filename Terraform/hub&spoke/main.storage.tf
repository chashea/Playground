resource "azurerm_resource_group" "rg_stg" {
  name     = "${module.naming.resource_group.name}-stg"
  location = "eastus2"
}

module "storage" {
  source                          = "Azure/avm-res-storage-storageaccount/azurerm"
  version                         = "0.2.1"
  name                            = module.naming.storage_account.name_unique
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = "Premium"
  account_replication_type        = "ZRS"
  default_to_oauth_authentication = true
}

