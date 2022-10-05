module "resource_group" {
  source        = "./Modules/resource-group"
  rg_name       = "RG-WUS"
  rg_location   = "WestUS"
  rg_tags       = {
    "Environment" = "Dev"
    "Owner"       = "chashea"
    "Project"     = "Terraform"
  }
}

