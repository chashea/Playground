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


module "hub_net" {
  source                = "./Modules/networking/hub-net"
  rg_name               = module.resource_group.rg_name
  rg_location           = module.resource_group.rg_location
  rg_tags               = module.resource_group.rg_tags
  hub_net_name          = "HubNet"
  hub_net_address_space = "10.1.0.0/16"
  dns_servers           = ["10.1.0.4", "10.1.0.5"] 
  hub_net_subnet_name   = "HubNetSubnet"
  hub_net_subnet_address_prefix = "10.1.0.0/24"
  }


module "spoke_net" {
  source                = "./Modules/networking/spoke-net"
  rg_name               = module.resource_group.rg_name
  rg_location           = module.resource_group.rg_location
  rg_tags               = module.resource_group.rg_tags
  spoke_net_name        = "SpokeNet"
  spoke_net_address_space = "10.2.0.0/16"
  spoke_net_subnet_name = "SpokeNetSubnet"
  spoke_subnet_address_prefix = "10.2.0.0/24"
}


module "flex" {
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
  flex_create_mode                  = "GeoRestore"
  flex_geo_redundant_backup_enabled = true
  flex_availability_zone            = "1,2,3"
  flex_high_availability            = "ZoneRedundant"
  flex_source_server_id             = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/RG-WUS/providers/Microsoft.DBforMySQL/flexibleServers/mysqlserverflex"
  flex_db_name                      = "mysqldbflex"
  flex_db_charset                   = "utf8"
  flex_db_collation                 = "utf8_general_ci"
}


