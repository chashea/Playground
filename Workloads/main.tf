locals {
  name_suffix = "${var.workload_name}-${var.environment}"
}

module "resource_group" {
  source              = "./Modules/resource group"
  resource_group_name = var.resource_group_name
}

module "waf_policy" {
  source              = "./Modules/waf-policy"
  resource_group_name = module.resource_group.resource_group_name
  resource_suffix     = local.name_suffix
  resource_instance   = 001
  resource_tags       = var.resource_tags
}

