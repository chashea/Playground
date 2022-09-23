resource "azurerm_virtual_network" "hub-vnet" {
  name = "${var.hub-vnet-name}"
  location = var.hub-vnet-location
  address_space = [ "10.0.0.0/16" ]

}