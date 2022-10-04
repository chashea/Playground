output "ase_subnet_id" {
  value = azurerm_subnet.ase_subnet.id
}

output "ase_id" {
  value = azurerm_app_service_environment.ase.id
}

