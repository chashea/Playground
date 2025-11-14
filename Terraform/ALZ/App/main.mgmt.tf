module "kv-mgmt" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.10.2"
  name                = "kv-app-eus-${random_string.suffix.result}-001"
  resource_group_name = local.resource_groups["app_conn"].name
  location            = local.resource_groups["app_conn"].location
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_storage_account" "stg-mgmt" {
  name                     = "stgflowmgmtapp${random_string.suffix.result}eus001"
  resource_group_name      = local.resource_groups["app_mgmt"].name
  location                 = local.resource_groups["app_mgmt"].location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  depends_on               = [module.resource_groups]
}

module "law-mgmt" {
  source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version             = "0.4.2"
  name                = "logmgmt-eus-001"
  resource_group_name = local.resource_groups["app_mgmt"].name
  location            = local.resource_groups["app_mgmt"].location
}

