# Hub Peering Output
output "hub_peering_name" {
  value = azurerm_virtual_network_peering.hub.name
}

output "hub_peering_id" {
  value = azurerm_virtual_network_peering.hub.id
}


# Spoke Peering Output

output "spoke_peering_name" {
  value = azurerm_virtual_network_peering.spoke.name
}

output "spoke_peering_id" {
  value = azurerm_virtual_network_peering.spoke.id
}



