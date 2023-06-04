// Create an output for VNet Name
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

// Create an output for VNet Resource Group Name
output "vnet_rg_name" {
  value = azurerm_resource_group.rg.name
}

