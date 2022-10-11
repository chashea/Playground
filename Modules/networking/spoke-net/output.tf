output "spoke_net_id" {
  value = data.azurerm_virtual_network.spoke_net.id
}

output "subnet_id" {
  value = data.azurerm_subnet.subnet_name.id
}

