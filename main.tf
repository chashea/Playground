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


module "firewall" {
  source        = "./Modules/networking/firewall"
  resource_group_name = module.resource_group.resource_group_name
  fw_public_ip = var.fw_pip_name
  fw_subnet_id = module.hub_net.subnet_id
}

