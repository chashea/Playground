provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false // Set to True for Production
    }
  }
}

// Create a Module for Virtual Network and Subnet
module "net" {
  source                  = "./Modules/net"
  location                = var.location
  environment             = var.environment
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
}
