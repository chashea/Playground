locals {
  common_tags = {
    created_by  = "terraform"
    project     = "Azure Landing Zones"
    owner       = "Charles Shea"
    EndDate     = "2025-12-31"
    environment = "demo"
  }
  resource_groups = {
    hub_conn = {
      name     = "rg-hub-conn-${random_string.suffix.result}"
      location = "eastus"
    }
    hub_mgmt = {
      name = "rg-hub-mgmt-${random_string.suffix.result}"
      location = "eastus"
    }
  }
}

