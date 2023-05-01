// Create an output for VNet Name
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

// Create an output for Firewall Subnet ID
output "fw_subnet_id" {
  value = azurerm_subnet.subnet_fw.id
}


