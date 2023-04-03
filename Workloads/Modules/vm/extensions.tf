// Create Virtual Machine extension for AAD JOin
resource "azurerm_virtual_machine_extension" "aad_join" {
  name                       = "aad_join"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}


// Createa Virtual Machine extention for MMA Agent
resource "azurerm_virtual_machine_extension" "mma_agent" {
  name                       = "mma_agent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
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
    azurerm_windows_virtual_machine.vm,
    var.law_key
  ]
}
/*
// Create a Virtual Machine extension for AMA Agent

resource "azurerm_virtual_machine_extension" "ama_agent" {
  name                       = "ama_agent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
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
    azurerm_windows_virtual_machine.vm,
    var.law_key
  ]
}
*/
