// Create a Resource Group for the Log Analytics Workspace
resource "azurerm_resource_group" "rg_law" {
  name     = "rg-law-${var.location}-${var.environment}"
  location = var.location
  tags     = var.tags
}

// Create a Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.prefix}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_law.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}
