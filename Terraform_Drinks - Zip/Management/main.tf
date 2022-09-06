# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  # Jorge subscription_id = "75149352-2e54-4cad-ae5f-93718720f2e4"
  # Ricardo subscription_id = "d9759156-c58b-4373-b08a-e7b28d114df4"
  subscription_id = "d9759156-c58b-4373-b08a-e7b28d114df4"
  tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}

# Create Azure Resource Group
module rg {
  source = "../modules/resource_group"
  for_each = var.resource_group

  resource_group_name = each.value.name
  location = each.value.location
  tags = each.value.tags
}

# Create Azure Virtual Network and Subnet
module vnet {
  source = "../modules/vnet"
  for_each = var.virtual_network

  virtual_network_name            = each.value.virtual_network_name
  virtual_network_address_space   = each.value.virtual_network_address_space
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  subnets                         = each.value.subnets
  tags                            = each.value.tags
  depends_on = [
    module.rg
  ]
}

module "vnet_peering" {
  source = "../modules/vnet_peering"
  for_each = var.virtual_network_peering

  peering_name                 = each.value.peering_name
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = each.value.virtual_network_name
  remote_virtual_network_id    = each.value.remote_virtual_network_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways  

  depends_on = [
    module.vnet
  ]
}