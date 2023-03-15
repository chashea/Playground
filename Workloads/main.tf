provider "azurerm" {
  features {}
}

module "vnet" {
  source      = "./Modules/vnet"
  location    = "eastus"
  environment = "dev"
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}