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
    "workspaceId": "${data.azurerm_log_analytics_workspace.law.id}"
  }
    SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
    {
        "workspaceKey": "${data.azurerm_log_analytics_workspace.law.primary_shared_key}"
        }
    PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.aad_join,
    data.azurerm_log_analytics_workspace.law
  ]
}


