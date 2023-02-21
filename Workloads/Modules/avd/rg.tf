//Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.resource_location
  tags     = var.resource_tags
}