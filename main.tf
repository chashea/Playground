locals {
  name_suffix = "${var.worload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source        = "./Modules/resource_group"
  resource_group_location   = "WestUS"
  resource_suffix = local.name_suffix
  resource_instance = "01"
  resource_tags       = {
    "Environment" = "Dev"
    "Owner"       = "chashea"
    "Project"     = "Terraform"
  }
}

module "web_app" {
  source        = "./Modules/web_app"
  resource_group_name       = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  resource_suffix           = local.name_suffix
  resource_instance         = "001"
  resource_tags             = module.resource_group.resource_tags
  ase_subnet_id             = "ase-subnet-id"
  asp_os_type               = "Windows"
  asp_sku_name              = "S1"
}


module "mysql" {
  source        = "./Modules/mysql/single"
  resource_group_name       = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  resource_suffix           = local.name_suffix
  resource_instance         = "001"
  resource_tags             = module.resource_group.resource_tags
  mysql_sku_name            = "GP_Gen5_2"
  mysql_version             = "5.7"
  mysql_storage_mb          = "5120"
  mysql_ssl_enforcement_enabled = true

}