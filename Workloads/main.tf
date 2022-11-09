locals {
  name_suffix = "${var.workload_name}-${var.environment}"
}

module "resource_group" {
  source              = "./Modules/resource group"
  resource_group_name = var.resource_group_name
}



