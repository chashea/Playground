module "rt-app" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.4.1"
  name                = "rt-hub-conn-eus-${random_string.suffix.result}-001"
  location            = local.resource_groups["hub_conn"].location
  resource_group_name = module.resource_groups["hub_conn"].name
  depends_on          = [module.resource_groups["hub_conn"], module.vnet-hub]
  subnet_resource_ids = {
    subnet01 = module.vnet-hub.subnets["subnet01"].resource_id
  }
  routes = {
    route-nva = {
      name                   = "route-nva-001"
      address_prefix         = "10.100.0.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.0.1" # IP of the NVA in the hub
    }
  }
}

module "nsg-app" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.5.0"
  name                = "nsg-app-conn-eus-${random_string.suffix.result}-001"
  location            = local.resource_groups["hub_conn"].location
  resource_group_name = module.resource_groups["hub_conn"].name
  depends_on          = [module.resource_groups["hub_conn"]]
}

module "vnet-hub" {
  source        = "Azure/avm-res-network-virtualnetwork/azurerm"
  version       = "0.15.0"
  location      = local.resource_groups["hub_conn"].location
  parent_id     = module.resource_groups["hub_conn"].resource_id
  address_space = ["10.100.0.0/16"]
  name          = "vnet-app-conn-eus-${random_string.suffix.result}-001"
  depends_on    = [module.resource_groups["hub_conn"]]
  subnets = {
    subnet01 = {
      name           = "snet-app-conn-001"
      address_prefix = "10.100.0.0/26"
      networksecuritygroup = {
        id = module.nsg-app.resource_id
      }
    }
  }
}

module "fw" {
  source              = "Azure/avm-res-network-azurefirewall/azurerm"
  version             = "0.4.0"
  name                = "fw-hub-conn-eus-${random_string.suffix.result}-001"
  location            = local.resource_groups["hub_conn"].location
  resource_group_name = module.resource_groups["hub_conn"].name
  firewall_sku_name   = "AZFW_VNet"
  firewall_sku_tier   = "Premium"
  depends_on          = [module.resource_groups["hub_conn"]]
}

module "fwpolicy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"
  version             = "0.3.4"
  name                = "fwpolicy-hub-conn-eus-${random_string.suffix.result}-001"
  location            = local.resource_groups["hub_conn"].location
  resource_group_name = module.resource_groups["hub_conn"].name
  depends_on          = [module.resource_groups["hub_conn"]]
}

