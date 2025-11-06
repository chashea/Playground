# Generate VM local password
resource "random_password" "vmpass" {
  length  = 20
  special = true
}

resource "azurerm_windows_virtual_machine" "this" {
  count = var.vm_count

  admin_password             = random_password.vmpass.result
  admin_username             = "adminuser"
  location                   = azurerm_resource_group.this.location
  name                       = "${var.avd_vm_name}-${count.index}"
  network_interface_ids      = [azurerm_network_interface.this[count.index].id]
  resource_group_name        = azurerm_resource_group.this.name
  size                       = "Standard_D2s_v4"
  computer_name              = "${var.avd_vm_name}-${count.index}"
  encryption_at_host_enabled = true
  secure_boot_enabled        = true
  vtpm_enabled               = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    name                 = "${var.avd_vm_name}-${count.index}-osdisk"
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }
  source_image_reference {
    offer     = "windows-11"
    publisher = "microsoftwindowsdesktop"
    sku       = "win11-23h2-avd"
    version   = "latest"
  }
}

# Virtual Machine Extension for AMA agent
resource "azurerm_virtual_machine_extension" "ama" {
  count = var.vm_count

  name                      = "AzureMonitorWindowsAgent-${count.index}"
  publisher                 = "Microsoft.Azure.Monitor"
  type                      = "AzureMonitorWindowsAgent"
  type_handler_version      = "1.2"
  virtual_machine_id        = azurerm_windows_virtual_machine.this[count.index].id
  automatic_upgrade_enabled = true

  depends_on = [module.avd]
}

# Virtual Machine Extension for AAD Join
resource "azurerm_virtual_machine_extension" "aadjoin" {
  count = var.vm_count

  name                       = "${var.avd_vm_name}-${count.index}-aadJoin"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "2.0"
  virtual_machine_id         = azurerm_windows_virtual_machine.this[count.index].id
  auto_upgrade_minor_version = true
}

# Virtual Machine Extension for AVD Agent
resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  count = var.vm_count

  name                       = "${var.avd_vm_name}-${count.index}-avd_dsc"
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  virtual_machine_id         = azurerm_windows_virtual_machine.this[count.index].id
  auto_upgrade_minor_version = true
  protected_settings         = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${module.avd.registrationinfo_token}"
    }
  }
PROTECTED_SETTINGS
  settings                   = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02714.342.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${module.avd.virtual_desktop_host_pool_name}"
    }
 }
  SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.aadjoin,
    module.avd
  ]
}