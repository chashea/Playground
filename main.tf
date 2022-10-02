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


module "bastion_host" {
  source                = "./Modules/networking/bastion"
  rg_name               = module.resource_group.rg_name
  rg_location           = module.resource_group.rg_location
  rg_tags               = module.resource_group.rg_tags
  hub_net               = module.hub_net.hub_net_name
  bastion_host_name     = "BastionHost"
  bastion_subnet_name   = "AzureBastionSubnet"
  bastion_subnet_address_prefixes = "10.1.0.64/26"
  bastion_public_ip_name = "BastionPublicIP"
  bastion_public_ip_sku = "Standard"
  bastion_public_ip_allocation_method = "Static"
  bastion_ip_configuration_name = "BastionIPConfiguration"
  bastion_file_copy_enabled = true
  bastion_scale_units = 1
  shareable_link_enabled = true
  bastion_tunneling_enabled = true

    
  }

