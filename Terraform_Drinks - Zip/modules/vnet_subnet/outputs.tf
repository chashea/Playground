output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "The ID of the Subnet."
}

output "subnet_name" {
  value       = azurerm_subnet.subnet.name
  description = "Subnet Name."
}