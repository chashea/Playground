module "resource-group" {
  source        = "./Modules/resource-group"
  rg-name       = "RG-WUS"
  rg-location   = "WestUS"
}

module "hub-net" {
  source            = "./Modules/hub-net"
  hub-net-name      = "vnet-hub-wus"
  hub-net-location  = module.resource-group.resource_group_location
  hub-net-rg        = module.resource-group.resource_group_name
  }
