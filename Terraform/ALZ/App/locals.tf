locals {
  common_tags = {
    created_by  = "terraform"
    project     = "Azure Landing Zones"
    owner       = "Charles Shea"
    EndDate     = "2025-12-31"
    environment = "demo"
  }
  resource_groups = {
    app_conn = {
      name     = "rg-app-conn-${random_string.suffix.result}"
      location = "eastus"
    }
    app_mgmt = {
      name     = "rg-app-mgmt-${random_string.suffix.result}"
      location = "eastus"
    }
  }
  network_watcher_name                = "NetworkWatcher_${local.resource_groups["app_mgmt"].location}"
  network_watcher_resource_group_name = "NetworkWatcherRG"
  tags = {
    scenario = "Network Watcher Flow Logs AVM Sample"
  }
}

