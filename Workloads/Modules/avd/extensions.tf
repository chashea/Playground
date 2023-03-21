// Create Virtual Machine extension for AAD JOin
resource "azurerm_virtual_machine_extension" "aad_join" {
  count                      = 1
  name                       = "aad_join-${count.index + 1}"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true
}

// Create Virtual Machine extension for DSC
resource "azurerm_virtual_machine_extension" "dsc" {
  count                      = 1
  name                       = "dsc-${count.index + 1}"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[count.index].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.80"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
       {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.avd_host_pool.name}"
      }
    }
    SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.aad_join,
    var.law_key
  ]
}

// Createa Virtual Machine extention for MMA Agent
resource "azurerm_virtual_machine_extension" "mma_agent" {
  count                      = 1
  name                       = "mma_agent-${count.index + 1}"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm[count.index].id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForWindows"
  type_handler_version       = "1.12"
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