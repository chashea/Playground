locals {
  name_suffix = "${var.workload_name}-${var.environment}-${var.resource_location}"
}

module "network" {
  source = "./network"
  # Resource Group
  resource_group_name = "rg-${var.workload_name}-${var.environment}-${var.resource_location}"
  resource_location   = var.resource_location
  resource_tags       = var.resource_tags
  #Subscriptions
  hub_subscription_id   = var.hub_subscription_id
  spoke_subscription_id = var.spoke_subscription_id
  # Virtual Network
  hub_vnet_name   = var.hub_vnet_name
  spoke_vnet_name = "vnet-${var.workload_name}-${var.environment}-${var.resource_location}"
  subnet_range    = ["10.2.0.0/24"]
  nsg_name        = "nsg-${var.workload_name}-${var.environment}-${var.resource_location}"

}

