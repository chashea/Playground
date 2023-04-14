// Create Virtual Machine extension for AAD JOin
resource "azurerm_virtual_machine_extension" "aad_join" {
  count                      = 1
  name                       = "aad_join-${count.index + 1}"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[count.index].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

// Create Virtual Machine extension for DSC
resource "azurerm_virtual_machine_extension" "dsc" {
  count                      = 1
  name                       = "dsc-${count.index + 1}"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[count.index].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
       {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.avd_host_pool.name}"
      }
    }
    SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.aad_join,
    azurerm_virtual_desktop_host_pool.avd_host_pool,
    var.law_key
  ]
}

// Createa Virtual Machine extention for MMA Agent
resource "azurerm_virtual_machine_extension" "mma_agent" {
  count                      = 1
  name                       = "mma_agent-${count.index + 1}"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[count.index].id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
  {
    "workspaceId": "${var.law_id}"
  }
    SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
    {
        "workspaceKey": "${var.law_key}"
        }
    PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.aad_join,
    azurerm_virtual_machine_extension.dsc,
    var.law_key
  ]
}