// Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-net-${var.location}-${var.environment}"
  location = var.location
  tags     = var.tags
}

// Create a Windows VM
resource "azurerm_windows_virtual_machine" "vm" {
  name                       = "vm-${var.location}-${var.environment}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  size                       = var.vm_size
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  network_interface_ids      = [azurerm_network_interface.nic.id]
  encryption_at_host_enabled = true
  tags                       = var.tags
  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_encryption_set_id = var.disk_encryption_set_id
    disk_size_gb = "128"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-entn"
    version   = "latest"
  }

}
