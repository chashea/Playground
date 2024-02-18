# This is required for resource modules
resource "azurerm_resource_group" "rg" {
  name     = "rg-stg-terraform"
  location = "eastus"
}


module "avm-res-storage-storageaccount" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.1.0"
  # insert the 2 required variables here
  name                = "chasheastgterraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}