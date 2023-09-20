// Create a Resource Group for AVD
resource "azurerm_resource_group" "rg_avd" {
  name     = "rg-avd-${var.location}-${var.environment}"
  location = var.location
  tags     = var.tags
}

// Create an Azure Virtual Desktop Host Pool
resource "azurerm_virtual_desktop_host_pool" "avd_host_pool" {
  name                             = "avd-hp-${var.location}-${var.environment}-001"
  location                         = var.location
  resource_group_name              = azurerm_resource_group.rg_avd.name
  type                             = "Personal"
  personal_desktop_assignment_type = "Automatic"
  load_balancer_type               = "Persistent"
  start_vm_on_connect              = true
  tags                             = var.tags
}

// Create an Azure Virtual Desktop Host Pool Registration Info
resource "azurerm_virtual_desktop_host_pool_registration_info" "avd_host_pool_registration_info" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd_host_pool.id
  expiration_date = timeadd(timestamp(), "48h")
}

// Create an Azure Virtual Desktop Application Group
resource "azurerm_virtual_desktop_application_group" "avd_app_group" {
  name                = "avd-ag-${var.location}-${var.environment}-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_avd.name
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.avd_host_pool.id
  friendly_name       = "AVD App Group"
  description         = "AVD App Group"
  tags                = var.tags
}

// Create an Azure Virtual Desktop Workspace
resource "azurerm_virtual_desktop_workspace" "avd_workspace" {
  name                = "avd-ws-${var.location}-${var.environment}-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_avd.name
  friendly_name       = "AVD Workspace"
  description         = "AVD Workspace"
  tags                = var.tags
}

// Create an Azure Virtual Desktop Workspace Application Group Association
resource "azurerm_virtual_desktop_workspace_application_group_association" "avd_workspace_app_group_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.avd_workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.avd_app_group.id
}


