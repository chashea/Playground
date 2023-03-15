// Create a Windows VM

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm-${var.location}-${var.environment}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]
  tags                  = var.tags
}
