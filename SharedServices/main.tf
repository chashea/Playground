module "resource_group" {
  source              = "./Modules/resource group"
  resource_group_name = var.resource_group_name
}

module "firewall_policy" {
  source                  = "./Modules/firewall-policy"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.location
  resource_tags           = var.resource_tags
}