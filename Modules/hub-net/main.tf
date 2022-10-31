data "azurerm_virtual_network" "hub_net" {
  name = var.hub_net_name
  resource_group_name = var.resource_group_name
}
  
