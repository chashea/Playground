// Create AVD Resource
resource "azurerm_virtual_desktop_host_pool" "avd_hostpool" {
  name                             = local.hp_name
  location                         = var.resource_location
  resource_group_name              = azurerm_resource_group.rg.name
  type                             = "Pooled"
  load_balancer_type               = "BreadthFirst"
  personal_desktop_assignment_type = "Automatic"
  validate_environment             = true
  start_vm_on_connect              = true
  tags                             = var.resource_tags
}
// create hostpool registration
resource "azurerm_virtual_desktop_host_pool_registration_info" "avd_hostpool_registration" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd_hostpool.id
  expiration_date = "2023-02-24T23:40:52Z"
}
// create AVD Workspace
resource "azurerm_virtual_desktop_workspace" "avd_workspace" {
  name                = local.ws_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  friendly_name       = "AVD Workspace"
  description         = "AVD Workspace"
  tags                = azurerm_resource_group.rg.tags
}
// create Application Group resource
resource "azurerm_virtual_desktop_application_group" "avd_appgroup" {
  name                = local.ag_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.avd_hostpool.id
  friendly_name       = "AVD App Group"
  description         = "AVD App Group"
  tags                = azurerm_resource_group.rg.tags
}

// create workspace associtation
resource "azurerm_virtual_desktop_workspace_application_group_association" "avd_workspace_appgroup_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.avd_workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.avd_appgroup.id
}

