output "location" {
  value = data.azurerm_virtual_network.vnet.location
  description = "Region that Azure VNet"
}

output "name" {
  value = azurerm_linux_virtual_machine.vm.name
  description = "Azure VM Name"
}

output "vm_pip" {
  value       = azurerm_public_ip.vmpip.*.ip_address
  description = "VM Public IP"
}

output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = azurerm_network_interface.vmnic.*.private_ip_address
}