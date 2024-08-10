terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "terraformbackendstg"
    container_name       = "terraformbackend"
    key                  = "vwan.tfstate"
  }
}