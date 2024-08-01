module "storage" {
  source              = "Azure/avm-res-storage-storageaccount/azurerm"
  version             = "0.2.1"
  name                = module.naming.storage_account.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

