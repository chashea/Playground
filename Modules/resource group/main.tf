# Resource Group
resource "azurerm_resource_group" "resource_group" {
  name = "rg-${var.resource_suffix}${var.resource_instance}"
  location = var.resource_group_location
  tags = var.resource_tags
}





