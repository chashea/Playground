output "location" {
  value = azurerm_network_security_group.nsg.location
  description = "Region that Azure VNet"
}

output "name" {
  value = azurerm_network_security_group.nsg.name
  description = "Azure Vnet Name"
}

output "id" {
  value       = azurerm_network_security_group.nsg.id
  description = "The ID of the VNet."
}