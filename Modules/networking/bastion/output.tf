output "bastion_subnet_name" {
  value = azurerm_subnet.bastion_subnet.name
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}

output "bastion_public_ip_id" {
  value = azurerm_public_ip.bastion_pip.id
}


output "bastion_subnet_address_prefix" {
  value = azurerm_subnet.bastion_subnet.address_prefix
}

output "bastion_subnet_address_prefixes" {
  value = azurerm_subnet.bastion_subnet.address_prefixes
}

output "bastion_subnet_service_endpoints" {
  value = azurerm_subnet.bastion_subnet.service_endpoints
}

