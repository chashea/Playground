// Create a nic for AVD Session Hosts
resource "azurerm_network_interface" "nic" {
  count               = 1
  name                = "nic-avd-${var.location}-${var.environment}-${count.index + 1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_avd.name
  tags                = var.tags
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.avd_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

// Create VMs for AVD Session Hosts
resource "azurerm_windows_virtual_machine" "avd_vm" {
  count                      = 1
  name                       = "sh-vm-${count.index + 1}"
  resource_group_name        = azurerm_resource_group.rg_avd.name
  location                   = var.location
  size                       = "Standard_D4s_v3"
  admin_username             = "chashea"
  admin_password             = "Password1234!"
  network_interface_ids      = [azurerm_network_interface.nic[count.index].id]
  provision_vm_agent         = true
  encryption_at_host_enabled = true
  tags                       = var.tags
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = "128"
  }
  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-entn"
    version   = "latest"
  }
}