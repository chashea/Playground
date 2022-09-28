# Resource Group
resource "azurerm_resource_group" "rg" {
  name = "${var.rg_name}"
  location = var.rg_location
  tags = {
    Environemnt = "Pre-Prod"
    Team        = "FTA"
    Deployment  = "Terraform"
  }
}




