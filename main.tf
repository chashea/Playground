module "resource_group" {
  source        = "./Modules/resource-group"
  rg_name       = "RG-WUS"
  rg_location   = "WestUS"
  rg_tags       = {
    "Environment" = "Dev"
    "Owner"       = "chashea"
    "Project"     = "Terraform"
  }
}

module "mysql" {
  source                            = "./Modules/mysql/flex"
  rg_name                           = module.resource_group.rg_name
  rg_location                       = module.resource_group.rg_location
  rg_tags                           = module.resource_group.rg_tags
  flex_server_name                  = "mysqlserverflex"
  flex_administrator_login          = "mysqladmin"
  flex_administrator_password       = "P@ssw0rd1234"
  flex_sku_name                     = "B_Standard_B1s"
  flex_backup_retention_days        = 7
  flex_version                      = "8.0.21"
  flex_create_mode                  = "Default"
  flex_geo_redundant_backup_enabled = true
  flex_availability_zone            = "1,2,3"
  flex_high_availability            = "ZoneRedundant"
  flex_db_name                      = "mysqldbflex"
  flex_db_charset                   = "utf8"
  flex_db_collation                 = "utf8_general_ci"
}


