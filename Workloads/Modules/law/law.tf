provider "azurerm" {
  features {
    log_analytics_workspace {
      permanetly_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false // Set to True for Production
    }
  }
}

// Create a Resource Group for the Log Analytics Workspace
resource "azurerm_resource_group" "rg" {
  name     = "rg-law-${var.location}-${var.environment}"
  location = var.location
  tags     = var.tags
}

// Create a Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.prefix}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}
