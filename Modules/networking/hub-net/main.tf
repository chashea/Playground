data "azurerm_virtual_network" "hub_net_name" {
  name = var.hub_net_name
  resource_group_name = var.resource_group_name
}
  

data "azurerm_subnet" "fw_subnet_name" {
  name = var.fw_subnet_name
  virtual_network_name = var.hub_net_name
  resource_group_name = var.resource_group_name
}


