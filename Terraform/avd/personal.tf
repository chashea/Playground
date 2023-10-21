// Create Personal HostPool

resource "azurerm_virtual_desktop_host_pool" "personal" {
  name                             = var.personal_hostpool_name
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  type                             = "Personal"
  load_balancer_type               = "Persistent"
  start_vm_on_connect              = true
  custom_rdp_properties            = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:0"
  validate_environment             = true
  personal_desktop_assignment_type = "Automatic"
}

// Create Personal HostPool Desktop Application Group

resource "azurerm_virtual_desktop_application_group" "personal_dag" {
  name                = var.personal_dag_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.personal.id
}

// Create Workspace Associated with Personal HostPool

resource "azurerm_virtual_desktop_workspace_application_group_association" "personal_app_group_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.personal_dag.id
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "personal_hostpool_registration_info" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.personal.id
  expiration_date = timeadd(timestamp(), "48h")
}

