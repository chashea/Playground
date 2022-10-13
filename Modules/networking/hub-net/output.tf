output "hub_net_id" {
  value = data.azurerm_virtual_network.hub_net.id
}

output "subnet_id" {
  value = data.azurerm_subnet.subnet_name.id
}

output "pip_address" {
  value = data.azurerm_public_ip.fw_pip.ip_address
}