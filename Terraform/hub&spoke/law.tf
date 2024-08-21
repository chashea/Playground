resource "azurerm_resource_group" "rg_law" {
  name     = "${module.naming.resource_group.name_unique}-workspace"
  location = "eastus2"
}

module "law" {
  source                                    = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version                                   = "0.3.2"
  resource_group_name                       = azurerm_resource_group.rg_law.name
  location                                  = azurerm_resource_group.rg_law.location
  name                                      = module.naming.log_analytics_workspace.name_unique
  log_analytics_workspace_retention_in_days = 30
  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_identity = {
    type = "SystemAssigned"
  }
}

