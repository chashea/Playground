local {
  rg_name = "rg-firewall-${var.environment}-${var.location}"
}

// Create a Resource Group for Azure Firewall
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}