locals {
  name_suffix = "${var.worload_name}-${var.environment}-${var.location}"
}

module "resource_group" {
  source        = "./Modules/resource-group"
  resource_group_name       = "RG-WUS"
  resource_group_location   = "WestUS"
  resource_group_tags       = {
    "Environment" = "Dev"
    "Owner"       = "chashea"
    "Project"     = "Terraform"
  }
}

