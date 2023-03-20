provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    virtual_machine {
      delete_os_disk_on_termination  = true
      skip_shutdown_and_force_delete = true
    }
  }
}

// Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-${var.location}-${var.environment}"
  location = var.location
  tags     = var.tags
}

// Create a Windows VM
resource "azurerm_windows_virtual_machine" "vm" {
  name                       = "vm-${var.location}-${var.environment}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  size                       = "Standard_D2s_v3"
  admin_username             = "chashea"
  admin_password             = "Password1234!"
  network_interface_ids      = [azurerm_network_interface.nic.id]
  encryption_at_host_enabled = true
  tags                       = var.tags
  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_encryption_set_id = var.disk_encryption_set_id
    disk_size_gb           = "128"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-entn"
    version   = "latest"
  }
}
