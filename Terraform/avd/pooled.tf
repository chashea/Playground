// Create Pooled HostPool

resource "azurerm_virtual_desktop_host_pool" "pooled" {
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  name                     = var.pooled_name
  friendly_name            = var.pooled_name
  description              = "Pooled Host Pool"
  type                     = "Pooled"
  validate_environment     = true
  maximum_sessions_allowed = 5
  preferred_app_group_type = "Desktop"
  start_vm_on_connect      = true
  custom_rdp_properties    = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:0"
  load_balancer_type       = "BreadthFirst"
  scheduled_agent_updates {
    enabled = false
  }
}

// Create Pooled HostPool Desktop Application Group

resource "azurerm_virtual_desktop_application_group" "dag" {
  name                = var.pooled_dag_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.pooled.id
}

// Create Pooled HostPool Desktop Workspace

resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  friendly_name       = var.workspace_name
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "app_group_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "pooled_hostpool_registration_info" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.pooled.id
  expiration_date = timeadd(timestamp(), "48h")
}
