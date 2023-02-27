provider "azurerm" {
  features {}
}

module "avd" {
  source                = "./Modules/avd"
  resource_location     = var.resource_location
  resource_tags         = var.resource_tags
  prefix                = var.prefix
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
  environment           = var.environment
  workload              = var.workload
  sh_count              = var.sh_count
}