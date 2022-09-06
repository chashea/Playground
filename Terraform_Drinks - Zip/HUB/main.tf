# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "4b4ea128-f1cf-47ab-8468-4e9e2ece06e6"
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

module "vnet_nsg" {
  source = "../modules/vnet_nsg"
  for_each = var.network_security_group

  nsg_name = each.value.nsg_name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
  nsg_rules = each.value.nsg_rules

  depends_on = [
    module.vnet
  ]  
}

module "vnet_subnet_nsg_association" {
  source = "../modules/vnet_subnet_nsg_association"
  
  subnet_id = module.vnet["vnet_prod"].subnets["test"].subnet_id
  network_security_group_id = module.vnet_nsg["NSG1"].id
  depends_on = [
    module.vnet_nsg
  ]
}

module "public_ip" {
  source = "../modules/public_ip"
  for_each = var.public_ip

  public_ip_name = each.value.public_ip_name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  tags = each.value.tags
  allocation_method = each.value.allocation_method
  sku = each.value.sku
}

module "firewall" {
  source = "../modules/firewall"

  firewall_name = var.firewall.firewall_name
  location = var.firewall.location
  resource_group_name = var.firewall.resource_group_name
  virtual_network_name = module.vnet["vnet_prod"].name
  public_ip_name = module.public_ip["fw_public_ip"].name
  tags = var.firewall.tags
  firewall_network_rule = var.firewall.firewall_network_rule
  #depends_on = [
  #  module.vnet
  #]  
}