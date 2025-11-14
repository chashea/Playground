data "azurerm_client_config" "current" {}

# data "azurerm_virtual_network" "hub_conn" {
#   name                = "vnet-hub-conn-eus-001"
#   resource_group_name = local.resource_groups["hub_conn"].name
# }