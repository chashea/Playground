output "hub_net_name" {
  value = azurerm_virtual_network.hub_net.name
}

output "hub_net_id" {
  value = azurerm_virtual_network.hub_net.id
}

output "hub_net_subnet_name" {
  value = azurerm_subnet.hub_net_subnet.name
}

output "hub_net_subnet_id" {
  value = azurerm_subnet.hub_net_subnet.id
}

