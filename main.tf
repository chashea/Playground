locals {
  name_suffix = "${var.workload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source        = "./Modules/resource group"
  resource_group_name = var.resource_group_name
}

module "hub_net" {
  source        = "./Modules/networking/hub-net"
  hub_net_name  = var.hub_net_name
  fw_subnet_name = var.fw_subnet_name
}

module "firewall_poilcy" {
  source        = "./Modules/networking/firewall-policy"
  resource_group_name = var.resource_group_name
}


module "firewall" {
  source        = "./Modules/networking/firewall"
  resource_group_name = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  resource_suffix = local.name_suffix
  resource_instance = "001"
  resource_tags = var.resource_tags
  fw_subnet_id = module.hub_net.fw_subnet_id
  fw_policy_id = module.firewall_poilcy.fw_policy_id
}

