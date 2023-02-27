resource "azurerm_network_interface" "avd_nic" {
  count                         = var.sh_count
  name                          = "${local.sh_nic_name}-${count.index + 1}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.resource_tags
}


resource "azurerm_windows_virtual_machine" "avd_vm" {
  count                      = var.sh_count
  name                       = "${local.sh_name}-${count.index + 1}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  size                       = "Standard_D4_v2"
  provision_vm_agent         = true
  admin_username             = local.admin_username
  admin_password             = local.admin_password
  network_interface_ids      = [azurerm_network_interface.avd_nic[count.index].id]
  encryption_at_host_enabled = true
  tags                       = var.resource_tags

  os_disk {
    name                 = "osdisk-${local.sh_name}-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 128
  }
  source_image_reference {
    publisher = "microsoft-azure-gaming"
    offer     = "game-dev-vm-preview"
    sku       = "win11_unreal_5_1"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "managed_disk" {
  count                = var.sh_count
  name                 = "data_disk-${local.sh_name}-${count.index + 1}"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
  tags                 = var.resource_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  count              = var.sh_count
  virtual_machine_id = azurerm_windows_virtual_machine.avd_vm[count.index].id
  managed_disk_id    = azurerm_managed_disk.managed_disk[count.index].id
  lun                = 3
  caching            = "ReadWrite"
}