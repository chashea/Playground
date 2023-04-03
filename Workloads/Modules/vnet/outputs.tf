// Create Outputs for Virtual Network and Subnet

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "avd_subnet_id" {
  value = azurerm_subnet.avd_subnet.id
}

