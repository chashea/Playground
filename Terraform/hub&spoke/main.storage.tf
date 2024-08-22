resource "azurerm_resource_group" "rg_stg" {
  name     = "${module.naming.resource_group.name_unique}-stg"
  location = "eastus2"
}

module "file_stg" {
  source                   = "Azure/avm-res-storage-storageaccount/azurerm"
  version                  = "0.2.3"
  name                     = "file${module.naming.storage_account.name_unique}"
  resource_group_name      = azurerm_resource_group.rg_stg.name
  location                 = azurerm_resource_group.rg_stg.location
  account_tier             = "Premium"
  account_replication_type = "ZRS"
  account_kind = "FileStorage"
  public_network_access_enabled = true
  default_to_oauth_authentication = true
}

module "stg" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.2.3"
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.rg_stg.name
  location                 = azurerm_resource_group.rg_stg.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  account_kind = "StorageV2"
  public_network_access_enabled = true
  default_to_oauth_authentication = true
}