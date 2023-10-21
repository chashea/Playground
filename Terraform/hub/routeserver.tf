// Create Public IP for Route Server

resource "azurerm_public_ip" "route_server_pip" {
  name                = var.route_server_pip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

// Create Route Server

resource "azurerm_route_server" "route_server" {
  name                             = var.route_server_name
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  public_ip_address_id             = azurerm_public_ip.route_server_pip.id
  sku                              = "Standard"
  subnet_id                        = azurerm_subnet.route_server_subnet.id
  branch_to_branch_traffic_enabled = true
}

resource "azurerm_route_server_bgp_connection" "route_server_bgp_connection" {
  name            = var.route_server_bgp_connection_name
  route_server_id = azurerm_route_server.route_server.id
  peer_asn        = 65001
  peer_ip         = "140.0.14.10"
}

