output "location" {
  value = azurerm_virtual_network.vnet.location
  description = "Region that Azure VNet"
}

output "name" {
  value = azurerm_virtual_network.vnet.name
  description = "Azure Vnet Name"
}

output "id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the VNet."
}

output "subnets" {
  value       = module.vnet_subnet
  description = "The ID of the VNet."
}