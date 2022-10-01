output "spoke_net_name" {
  value = azurerm_virtual_network.spoke_net_name.name
}

output "spoke_net_id" {
  value = azurerm_virtual_network.spoke_net_name.id
}

output "spoke_net_subnet_name" {
  value = azurerm_subnet.spoke_net_subnet.name
}

output "spoke_net_subnet_id" {
  value = azurerm_subnet.spoke_net_subnet.id
}

