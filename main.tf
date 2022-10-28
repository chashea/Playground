locals {
  name_suffix = "${var.workload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source              = "./Modules/resource group"
  resource_group_name = var.resource_group_name
}
/*
module "hub_net" {
  source              = "./Modules/networking/hub-net"
  resource_group_name = module.resource_group.resource_group_name
  hub_net_name        = var.hub_net_name
  subnet_name         = var.subnet_name
}
*/

module "spoke_net" {
  source              = "./Modules/networking/spoke-net"
  resource_group_name = module.resource_group.resource_group_name
  resource_suffix     = local.name_suffix
  resource_instance   = "001"
  resource_tags       = var.resource_tags
}


module "waf_policy" {
  source              = "./Modules/networking/wafpolicy"
  resource_group_name = module.resource_group.resource_group_name
  resource_suffix     = local.name_suffix
  resource_instance   = "001"
  resource_tags       = var.resource_tags
}

module "appgw" {
  source              = "./Modules/networking/appgw"
  resource_group_name = module.resource_group.resource_group_name
  resource_suffix     = local.name_suffix
  resource_instance   = "001"
  resource_tags       = var.resource_tags
}