output "location" {
  value = azurerm_resource_group.rg.location
  description = "Azure Resource Group Location"
}

output "name" {
  value = azurerm_resource_group.rg.name
  description = "Azure Resource Group Name"
}

output "id" {
  value       = azurerm_resource_group.rg.id
  description = "Azure Resource Group ID"
}