locals {
  name_suffix = "${var.workload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source        = "./Modules/resource group"
  resource_group_name = "rg-${local.name_suffix}"
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
  source        = "./Modules/web app"
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
  mysqlserver_sku_name            = "GP_Gen5_2"
  mysqlserver_version             = "5.7"
  mysqlserver_storage_mb          = "5120"
  mysqlserver_ssl_enforcement_enabled = true
  mysqldb_collation = "utf8_general_ci"
  mysqldb_charset = "utf8"


}