module "kv-mgmt" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.10.2"
  name                = "kv-app-eus-${random_string.suffix.result}-001"
  resource_group_name = local.resource_groups["app_mgmt"].name
  location            = local.resource_groups["app_mgmt"].location
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_storage_account" "stg-mgmt" {
  name                     = "stgflowmgmtapp${random_string.suffix.result}eus001"
  resource_group_name      = local.resource_groups["app_mgmt"].name
  location                 = local.resource_groups["app_mgmt"].location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [module.resource_groups]
}

module "law-mgmt" {
  source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version             = "0.4.2"
  name                = "logmgmt-eus-001"
  resource_group_name = local.resource_groups["app_mgmt"].name
  location            = local.resource_groups["app_mgmt"].location
}

resource "time_sleep" "wait_10_seconds_for_network_watcher_creation" {
  create_duration = "10s"

  depends_on = [module.vnet-app]
}

data "azurerm_network_watcher" "this" {
  name                = local.network_watcher_name
  resource_group_name = local.network_watcher_resource_group_name

  depends_on = [time_sleep.wait_10_seconds_for_network_watcher_creation]
}

module "network_watcher_flow_log" {
  source = "Azure/avm-res-network-networkwatcher/azurerm"

  location             = local.resource_groups["app_mgmt"].location
  network_watcher_id   = data.azurerm_network_watcher.this.id
  network_watcher_name = data.azurerm_network_watcher.this.name
  resource_group_name  = data.azurerm_network_watcher.this.resource_group_name
  flow_logs = {
    vnet_flowlog = {
      enabled            = true
      name               = "fl-vnet-app"
      target_resource_id = module.vnet-app.resource_id
      storage_account_id = azurerm_storage_account.stg-mgmt.id
      version            = 2
      retention_policy = {
        days    = 7
        enabled = true
      }
      traffic_analytics = {
        enabled               = true
        workspace_id          = nonsensitive(module.law-mgmt.resource.workspace_id)
        workspace_region      = local.resource_groups["app_mgmt"].location
        workspace_resource_id = module.law-mgmt.resource_id
        interval_in_minutes   = 10
      }
    }
  }
  tags = local.common_tags

  depends_on = [data.azurerm_network_watcher.this]
}