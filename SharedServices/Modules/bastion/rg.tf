// Create a Resource Group for Bastion Host
resource "azurerm_resource_group" "rg" {
  name     = local.bastion_rg_name
  location = var.location
  tags     = var.tags
}