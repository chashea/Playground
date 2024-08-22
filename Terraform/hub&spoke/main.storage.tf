resource "azurerm_resource_group" "rg_stg" {
  name     = "${module.naming.resource_group.name_unique}-stg"
  location = "eastus2"
}

module "file_stg" {
  source                   = "Azure/avm-res-storage-storageaccount/azurerm"
  version                  = "0.2.1"
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.rg_stg.name
  location                 = azurerm_resource_group.rg_stg.location
  account_tier             = "Premium"
  account_replication_type = "ZRS"
  account_kind = "FileStorage"
}

module "stg" {
  source                   = "Azure/avm-res-storage-storageaccount/azurerm"
  version                  = "0.2.1"
  name                     = "${module.naming.storage_account.name_unique}-blob"
  resource_group_name      = azurerm_resource_group.rg_stg.name
  location                 = azurerm_resource_group.rg_stg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
}

