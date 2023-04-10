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
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
}

// Create a Module for Bastion Host 
module "bastion" {
  source         = "./Modules/bastion"
  location       = var.location
  tags           = var.tags
  vnet_name      = module.net.vnet_name
  environment    = var.environment
  bastion_subnet = var.bastion_subnet
  depends_on = [
    module.net
  ]
}


/*
module "firewall_policy" {
  source                  = "./Modules/firewall-policy"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.location
  resource_tags           = var.resource_tags
}
module "firewall" {
  source                  = "./Modules/firewall"
  Location = var.location
  vnet                    = module.net.vnet_name
  tags           = var.tags
  environment             = var.environment
  fw_subnet               = var.fw_subnet
  fw_policy_id            = module.firewall_policy.fw_policy_id
depends on = [
    module.net,
    module.firewall_policy
  ]
}
*/


