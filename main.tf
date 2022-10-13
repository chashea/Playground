locals {
  name_suffix = "${var.workload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source        = "./Modules/resource group"
  resource_group_name = var.resource_group_name
}

module "hub_net" {
  source        = "./Modules/networking/hub-net"
  resource_group_name = module.resource_group.resource_group_name
  hub_net_name = var.hub_net_name
  subnet_name = var.subnet_name
}

/*
module "spoke_net" {
  source        = "./Modules/networking/spoke-net"
  resource_group_name = module.resource_group.resource_group_name
  spoke_net_name = var.spoke_net_name
  subnet_name = var.subnet_name
}
*/

/*
module "fw" {
  source        = "./Modules/networking/firewall"
  resource_group_name = module.resource_group.resource_group_name
  fw_pip_name = var.fw_pip_name
  fw_subnet_id = module.hub_net.subnet_id
  fw_public_ip_id = module.hub_net.public_ip_id
  fw_name = "azfw-${local.name_suffix}"
  fw_tags = var.resource_tags
}
*/