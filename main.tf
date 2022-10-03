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


module "hub_net" {
  source                = "./Modules/networking/hub-net"
  rg_name               = module.resource_group.rg_name
  rg_location           = module.resource_group.rg_location
  rg_tags               = module.resource_group.rg_tags
  hub_net_name          = "HubNet"
  hub_net_address_space = "10.1.0.0/16"
  dns_servers           = ["10.1.0.4", "10.1.0.5"] 
  hub_net_subnet_name   = "HubNetSubnet"
  hub_net_subnet_address_prefix = "10.1.0.0/26"
  }



module "spoke_net" {
  source                = "./Modules/networking/spoke-net"
  rg_name               = module.resource_group.rg_name
  rg_location           = module.resource_group.rg_location
  rg_tags               = module.resource_group.rg_tags
  spoke_net_name        = "SpokeNet"
  spoke_net_address_space = "11.1.0.0/16"
  spoke_net_subnet_name = "SpokeNetSubnet"
  spoke_subnet_address_prefix = "11.1.0.0/26"
  spoke_net_peering_name = module.peering.spoke_peering_name
  spoke_net_peering_remote_virtual_network_id = module.peering.hub_peering_id
  hub_net               = module.hub_net.hub_net_name
  }

  module "peering" {
    source              = "./Modules/networking/peering"
    rg_name             = module.resource_group.rg_name
    hub_net_name        = module.hub_net.hub_net_name
    hub_net_id          = module.hub_net.hub_net_id
    hub_peering_name    = "HubToSpoke"
    spoke_net_name      = module.spoke_net.spoke_net_name
    spoke_net_id        = module.spoke_net.spoke_net_id
    spoke_peering_name  = "SpokeToHub"
  }


