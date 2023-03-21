// Create Virtual Machine extension for AAD JOin
resource "azurerm_virtual_machine_extension" "aad_join" {
  name                       = "aad_join"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  virtual_machine_name       = azurerm_windows_virtual_machine.avd_vm[count.index].name
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true
}

// Create Virtual Machine extension for DSC
resource "azurerm_virtual_machine_extension" "dsc" {
  name                       = "dsc"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  virtual_machine_name       = azurerm_windows_virtual_machine.avd_vm[count.index].name
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.80"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
       {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.hostpool.name}"
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
  name                       = "mma_agent"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  virtual_machine_name       = azurerm_windows_virtual_machine.avd_vm[count.index].name
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