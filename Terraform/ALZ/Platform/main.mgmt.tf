data "azurerm_client_config" "current" {}

module "law-mgmt" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"
  name = "logmgmt-eus-001"
  resource_group_name = local.resource_groups["hub_mgmt"].name
  location = local.resource_groups["hub_mgmt"].location
}

resource "azurerm_monitor_diagnostic_setting" "fw_diag" {
  name = "diag-fw-mgmt-monitoring"
  target_resource_id = module.alznetwork.firewall_resource_ids["primary_hub"]
  log_analytics_workspace_id = module.law-mgmt.log_analytics_workspace.id
  enabled_log {
    category_group = "allLogs"
    }
  enabled_metric {
    category = "AllMetrics"
  }
}

module "kv-mgmt" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"
  name = "kv-mgmt-eus-001"
  resource_group_name = local.resource_groups["hub_mgmt"].name
  location = local.resource_groups["hub_mgmt"].location
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_storage_account" "stg-mgmt" {
  name                     = "stgflowmgmteus001"
  resource_group_name      = local.resource_groups["hub_mgmt"].name
  location                 = local.resource_groups["hub_mgmt"].location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
}

