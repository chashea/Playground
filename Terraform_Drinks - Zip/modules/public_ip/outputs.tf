output "location" {
  value = azurerm_public_ip.public_ip.location
  description = "Azure Resource Group Location"
}

output "name" {
  value = azurerm_public_ip.public_ip.name
  description = "Azure Public IP Name"
}

output "id" {
  value       = azurerm_public_ip.public_ip.id
  description = "Azure Public IP ID"
}

output "public_ip" {
  value       = azurerm_public_ip.public_ip
  description = "Azure Public IP object"
}