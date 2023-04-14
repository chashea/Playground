provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false // Set to True for Production
    }
  }
}

// Create a Module for Virtual Network and Subnet
module "hub_net" {
  source                  = "./Modules/hub_net"
  location                = var.location
  tags                    = var.tags
  environment             = var.environment
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  bastion_subnet          = var.bastion_subnet
  fw_subnet               = var.fw_subnet
}



