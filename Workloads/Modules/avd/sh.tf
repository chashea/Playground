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
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_size_gb           = "128"
  }
  source_image_reference {
    publisher = "microsoft-azure-gaming"
    offer     = "gamedev-vm"
    sku       = "win11_unreal_5_0"
    version   = "latest"
  }
}

// Create a Data Disk for AVD Session Hosts
resource "azurerm_managed_disk" "gdvm_data_disk" {
  count                = 1
  name                 = "avd-data-disk-${var.location}-${var.environment}-${count.index + 1}"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg_avd.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "255"
  tags                 = var.tags
}

// Create a Data Disk Attachment for AVD Session Hosts
resource "azurerm_virtual_machine_data_disk_attachment" "gdvm_data_disk_attachment" {
  count              = 1
  managed_disk_id    = azurerm_managed_disk.gdvm_data_disk[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.avd_vm[count.index].id
  lun                = "1"
  caching            = "ReadOnly"
  create_option      = "Attach"
  depends_on = [
    azurerm_windows_virtual_machine.avd_vm
  ]
}