resource "azurerm_virtual_network" "hub_net" {
  name                = var.hub_net_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  address_space       = [var.hub_net_address_space]
  dns_servers         = var.dns_servers
  tags                = var.rg_tags
}

resource "azurerm_subnet" "hub_net_subnet" {
  name                 = var.hub_net_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.hub_net.name
  address_prefixes     = [var.hub_net_subnet_address_prefix]
}

