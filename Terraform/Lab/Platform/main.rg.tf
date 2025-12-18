module "resource_groups" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.0"
  for_each         = local.resource_groups
  location         = each.value.location
  name             = each.value.name
  enable_telemetry = false
  tags             = local.common_tags
}

resource "random_string" "suffix" {
  length  = 4
  numeric = true
  special = false
  upper   = false
}
