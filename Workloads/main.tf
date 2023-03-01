provider "azurerm" {
  features {}
}

/*
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
*/

module "sentinel" {
  source = "./Modules/sentinel"
  prefix = var.prefix
  resource_location = var.resource_location
  resource_tags = var.resource_tags
  api_root_url = var.api_root_url
  collection_id = var.collection_id
}