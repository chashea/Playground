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
  }
}

