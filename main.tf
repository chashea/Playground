module "resource-group" {
  source        = "./Modules/resource-group"
  rg-name       = "RG-WUS"
  rg-location   = "WestUS"
}

## module "hub-net" {
##  source            = "./Modules/hub-net"
## hub-net-name      = "vnet-hub-wus"
## hub-net-location  = module.resource-group.resource_group_location
##  hub-net-rg        = module.resource-group.resource_group_name
##  }

module "mysql" {
  source            = "./Modules/mysql"
  mysqlserver_server_name = "mysqlserver-wus"
  mysqlserver_version = "5.7"
  mysqlserver_sku_name = "GP_Gen5_2"
  mysqlserver_storage_mb = 5120
  mysqldb_name = "mysqldb"
  mysqldb_charset = "utf8"
  mysqldb_collation = "utf8_general_ci"
  mysqlserver_location = module.resource-group.resource_group_location
  mysqlserver_rg = module.resource-group.resource_group_name
}
  