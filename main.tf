module "resource_group" {
  source        = "./Modules/resource-group"
  rg_name       = "RG-WUS"
  rg_location   = "WestUS"
}

module "mysql" {
  source                            = "./Modules/mysql/database"
  mysqlserver_server_name           = "mysqlserver-wus"
  rg_location                       = module.resource_group.rg_location
  rg_name                           = module.resource_group.rg_name 
  rg_tags                           = module.resource_group.rg_tags
  mysqlserver_version               = "5.7"
  mysqlserver_sku_name              = "GP_Gen5_2"
  mysqlserver_storage_mb            = 5120
  mysqldb_name                      = "mysqldb"
  mysqldb_charset                   = "utf8"
  mysqldb_collation                 = "utf8_general_ci"

}