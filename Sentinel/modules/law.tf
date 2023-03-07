// Create Log Analytics Workspace and Log Analytics Solution for Sentinel

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.prefix}-${var.resource_location}"
  location            = azurerm_resource_group.rg_law.location
  resource_group_name = azurerm_resource_group.rg_law.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "law_solution" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.rg_law.location
  resource_group_name   = azurerm_resource_group.rg_law.name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  tags                  = azurerm_resource_group.rg_law.tags

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

// Create resource to onboard Sentinel to Log Analytics Workspace
/* resource "azurerm_sentinel_log_analytics_workspace_onboarding" "law_onboarding" {
  resource_group_name        = azurerm_resource_group.rg_law.name
  workspace_name             = azurerm_log_analytics_workspace.law.name
}
*/

