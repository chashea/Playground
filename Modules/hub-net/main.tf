resource "azurerm_virtual_network" "hub-net" {
  name = "${var.hub-net-name}"
  location = var.hub-net-location
  address_space = [ "10.0.0.0/16" ]
  resource_group_name = var.hub-net-rg
  tags = var.hub-net-tags

}