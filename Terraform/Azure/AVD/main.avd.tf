module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = module.naming.resource_group.name_unique
  tags     = var.tags
}


module "avd" {
  source                                           = "Azure/avm-ptn-avd-lza-managementplane/azurerm"
  version                                          = "0.3.2"
  resource_group_name                              = azurerm_resource_group.this.name
  virtual_desktop_application_group_location       = azurerm_resource_group.this.location
  virtual_desktop_application_group_name           = var.virtual_desktop_application_group_name
  virtual_desktop_application_group_type           = var.virtual_desktop_application_group_type
  virtual_desktop_host_pool_load_balancer_type     = var.virtual_desktop_host_pool_load_balancer_type
  virtual_desktop_host_pool_location               = azurerm_resource_group.this.location
  virtual_desktop_host_pool_name                   = var.virtual_desktop_host_pool_name
  virtual_desktop_host_pool_type                   = var.virtual_desktop_host_pool_type
  virtual_desktop_scaling_plan_location            = azurerm_resource_group.this.location
  virtual_desktop_scaling_plan_name                = var.virtual_desktop_scaling_plan_name
  virtual_desktop_scaling_plan_resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_scaling_plan_schedule = [
    {
      name                                 = "Weekends"
      days_of_week                         = ["Saturday", "Sunday"]
      ramp_up_start_time                   = "06:00"
      ramp_up_load_balancing_algorithm     = "BreadthFirst"
      ramp_up_minimum_hosts_percent        = 20
      ramp_up_capacity_threshold_percent   = 10
      peak_start_time                      = "10:00"
      peak_load_balancing_algorithm        = "BreadthFirst"
      ramp_down_start_time                 = "18:00"
      ramp_down_load_balancing_algorithm   = "DepthFirst"
      ramp_down_minimum_hosts_percent      = 10
      ramp_down_force_logoff_users         = false
      ramp_down_wait_time_minutes          = 45
      ramp_down_notification_message       = "Please log off in the next 45 minutes..."
      ramp_down_capacity_threshold_percent = 5
      ramp_down_stop_hosts_when            = "ZeroSessions"
      off_peak_start_time                  = "22:00"
      off_peak_load_balancing_algorithm    = "DepthFirst"
    }
  ]
  virtual_desktop_scaling_plan_time_zone                = var.virtual_desktop_scaling_plan_time_zone
  virtual_desktop_workspace_location                    = azurerm_resource_group.this.location
  virtual_desktop_workspace_name                        = var.virtual_desktop_workspace_name
  enable_telemetry                                      = var.enable_telemetry
  public_network_access_enabled                         = false
  virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_host_pool_friendly_name               = var.virtual_desktop_host_pool_friendly_name
  virtual_desktop_host_pool_maximum_sessions_allowed    = var.virtual_desktop_host_pool_maximum_sessions_allowed
  virtual_desktop_host_pool_start_vm_on_connect         = var.virtual_desktop_host_pool_start_vm_on_connect
  virtual_desktop_host_pool_resource_group_name         = azurerm_resource_group.this.name
}