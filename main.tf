module "resource-group" {
  source = "./Modules/resource-group"
  rg-name = "RG-WUS"
  rg-location = "WestUS"
}

module "hub-net" {
  source = "./Modules/hub-net"
  hub-vnet-name = "vnet-hub-wus"
  location = azurerm_resource_group.rg.location
  tags = azurerm_resource_group.rg.tags
  resource_group_name = resource_group_name.rg.name

}