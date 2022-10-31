data "azurerm_virtual_network" "hub_net" {
  name = var.hub_net_name
  resource_group_name = var.resource_group_name
}
  
data "azurerm_subnet" "subnet_name" {
  name = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.hub_net.name
  resource_group_name = var.resource_group_name
}

