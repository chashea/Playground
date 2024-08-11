resource "azurerm_resource_group" "rg_stg" {
  name     = "${module.naming.resource_group.name}-stg"
  location = "eastus2"
}

resource "azurerm_storage_account" "stg" {
  name = module.naming.storage_account.name_unique
  resource_group_name = azurerm_resource_group.rg_stg.name
  location = azurerm_resource_group.rg_stg.location
  account_tier = "Premium"
  account_kind = "StorageV2"
  account_replication_type = "ZRS"
  default_to_oauth_authentication = true
  public_network_access_enabled = false
  shared_access_key_enabled = false
  https_traffic_only_enabled = true
  tags = {
    deployment = "terraform"
  }
}