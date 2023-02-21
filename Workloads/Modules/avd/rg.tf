//Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = locals.rg_name
  location = var.reource_location
  tags     = var.resource_tags
}