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
  tags                    = var.tags
  environment             = var.environment
  prefix                  = var.prefix
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
}

// Create a Module for Bastion
module "bastion" {
  source         = "./Modules/bastion"
  location       = var.location
  tags           = var.tags
  environment    = var.environment
  prefix         = var.prefix
  bastion_subnet = var.bastion_subnet
  vnet_name      = module.net.vnet_name
  depends_on     = [module.net]
}

// Create a Module for Azure Firewall
module "fw" {
  source      = "./Modules/fw"
  location    = var.location
  tags        = var.tags
  environment = var.environment
  prefix      = var.prefix
  vnet_name   = module.net.vnet_name
  fw_subnet   = var.fw_subnet
  depends_on  = [module.net, module.bastion]
}
