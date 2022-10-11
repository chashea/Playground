output "hub_net_id" {
  value = data.azurerm_virtual_network.hub_net_name.id
}

output "fw_subnet_id" {
  value = data.azurerm_subnet.fw_subnet_name.id
}


  