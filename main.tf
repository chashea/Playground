locals {
  name_suffix = "${var.worload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source        = "./Modules/resource-group"
  resource_group_name       = "RG-WUS"
  resource_group_location   = "WestUS"
  resource_group_tags       = {
    "Environment" = "Dev"
    "Owner"       = "chashea"
    "Project"     = "Terraform"
  }
}

module "web_app" {
  source        = "./Modules/web-app"
  resource_group_name       = module.resource_group.rg_name
  resource_group_location   = module.resource_group.rg_location
  resource_suffix           = local.name_suffix
  resource_instance         = "001"
  resource_tags             = module.resource_group.rg_tags
  ase_subnet_id             = "ase-subnet-id"
  asp_os_type               = "Windows"
  asp_sku_name              = "S1"
}