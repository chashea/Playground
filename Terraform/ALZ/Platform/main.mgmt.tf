module "law-mgmt" {
  source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version             = "0.4.2"
  name                = "logmgmt-eus-001"
  resource_group_name = local.resource_groups["hub_mgmt"].name
  location            = local.resource_groups["hub_mgmt"].location
}

resource "azurerm_monitor_diagnostic_setting" "fw_diag" {
  name                       = "diag-fw-mgmt-monitoring"
  target_resource_id         = module.alznetwork.firewall_resource_ids["primary_hub"]
  log_analytics_workspace_id = module.law-mgmt.resource_id
  enabled_log {
    category_group = "allLogs"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}

module "kv-mgmt" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.10.2"
  name                = "kv-mgmt-${random_string.suffix.result}-eus-001"
  resource_group_name = local.resource_groups["hub_mgmt"].name
  location            = local.resource_groups["hub_mgmt"].location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  depends_on          = [module.resource_groups]
}

resource "azurerm_storage_account" "stg-mgmt" {
  name                     = "stgflowmgmt${random_string.suffix.result}eus001"
  resource_group_name      = local.resource_groups["hub_mgmt"].name
  location                 = local.resource_groups["hub_mgmt"].location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  depends_on               = [module.resource_groups]
}


resource "time_sleep" "wait_10_seconds_for_network_watcher_creation" {
  create_duration = "10s"

  depends_on = [module.alznetwork]
}

data "azurerm_network_watcher" "this" {
  name                = local.network_watcher_name
  resource_group_name = local.network_watcher_resource_group_name

  depends_on = [time_sleep.wait_10_seconds_for_network_watcher_creation]
}

module "network_watcher_flow_log" {
  source = "Azure/avm-res-network-networkwatcher/azurerm"

  location             = local.resource_groups["hub_mgmt"].location
  network_watcher_id   = data.azurerm_network_watcher.this.id
  network_watcher_name = data.azurerm_network_watcher.this.name
  resource_group_name  = data.azurerm_network_watcher.this.resource_group_name
  flow_logs = {
    vnet_flowlog = {
      enabled            = true
      name               = "fl-vnet-conn"
      target_resource_id = module.alznetwork.virtual_network_resource_ids["primary_hub"]
      storage_account_id = azurerm_storage_account.stg-mgmt.id
      version            = 2
      retention_policy = {
        days    = 30
        enabled = true
      }
      traffic_analytics = {
        enabled               = true
        workspace_id          = nonsensitive(module.law-mgmt.resource.workspace_id)
        workspace_region      = local.resource_groups["hub_mgmt"].location
        workspace_resource_id = module.law-mgmt.resource_id
        interval_in_minutes   = 10
      }
    }
  }
  tags = local.common_tags

  depends_on = [data.azurerm_network_watcher.this]
}