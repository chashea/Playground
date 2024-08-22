resource "azurerm_resource_group" "rg_spoke" {
    name     = "${module.naming.resource_group.name_unique}-spoke"
    location = "eastus2" 
}

module "spoke_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.0"
  resource_group_name = azurerm_resource_group.rg_spoke.name
  location            = azurerm_resource_group.rg_spoke.location
  name                = "${module.naming.virtual_network.name_unique}-spoke"
  address_space       = ["10.100.0.0/16"]

  subnets = {
    subnet0 = {
      name             = "default-${module.naming.subnet.name_unique}"
      address_prefixes = ["10.100.0.0/24"]
      route_table = {
        id = azurerm_route_table.rt.id
      }
      network_security_group_resource_id = module.nsg.resource.id
    }
    subnet1 = {
      name             = "pe-${module.naming.subnet.name_unique}"
      address_prefixes = ["10.100.1.0/24"]
    }
  }
  peerings = {
    peering1 = {
      name                                 = "${module.naming.virtual_network_peering.name_unique}-spoke-to-hub"
      remote_virtual_network_resource_id   = module.hub_vnet.resource.id
      allow_virtual_network_access         = true
      allow_forwarded_traffic              = true
      allow_gateway_transit                = false
      use_remote_gateways                  = false
      create_reverse_peering               = true
      reverse_name                         = "${module.naming.virtual_network_peering.name_unique}-hub-to-spoke"
      reverse_allow_virtual_network_access = true
      reverse_allow_forwarded_traffic      = true
      reverse_allow_gateway_transit        = false
      reverse_use_remote_gateways          = false
    }
  }
}

resource "azurerm_route_table" "rt" {
  name                = "rt-001"
  resource_group_name = azurerm_resource_group.rg_spoke.name
  location            = azurerm_resource_group.rg_spoke.location
  route {
    name                   = "route-fw-outbound"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.200.0.4"
  }
}

module "nsg" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "0.2.0"
  resource_group_name = azurerm_resource_group.rg_spoke.name
  location            = azurerm_resource_group.rg_spoke
  name                = module.naming.network_security_group.name_unique
}
