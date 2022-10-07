locals {
  name_suffix = "${var.workload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source        = "./Modules/resource group"
  resource_group_name = var.resource_group_name
}


module "mysql" {
  source        = "./Modules/mysql/single"
  resource_group_name       = module.resource_group.resource_group_name
  resource_group_location   = module.resource_group.resource_group_location
  resource_suffix           = local.name_suffix
  resource_instance         = "001"
  resource_tags             = var.resource_tags
  mysqlserver_sku_name            = "GP_Gen5_2"
  mysqlserver_version             = "5.7"
  mysqlserver_storage_mb          = "5120"
  mysqlserver_ssl_enforcement_enabled = true
  mysqldb_collation = "utf8_general_ci"
  mysqldb_charset = "utf8"


}