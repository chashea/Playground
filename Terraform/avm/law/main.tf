resource "azurerm_resource_group" "example" {
    name     = var.rg_name
    location = var.location
}

resource "azurerm_log_analytics_workspace" "example" {
    name                = var.law_name
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name
    sku                 = var.law_sku
    retention_in_days   = var.law_retention_days
}
