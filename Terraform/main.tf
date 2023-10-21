provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      skip_shutdown_and_force_delete = true
    }
  }
}

module "hub" {
  source      = "./hub"
  rg_hub_name = var.rg_hub_name
  location    = var.location
  // VNet Variables
  hub_vnet_name              = var.hub_vnet_name
  hub_vnet_address            = var.hub_vnet_address
  fw_subnet_address           = var.fw_subnet_address
  bastion_subnet_address      = var.bastion_subnet_address
  route_server_subnet_address = var.route_server_subnet_address
  // Firewall Variables
  fw_pip_name           = var.fw_pip_name
  fw_name               = var.fw_name
  fw_sku_tier           = var.fw_sku_tier
  fw_sku_name           = var.fw_sku_name
  fw_ip_config_name     = var.fw_ip_config_name
  fw_parent_policy_name = var.fw_parent_policy_name
  // Bastion Variables
  bastion_pip_name       = var.bastion_pip_name
  bastion_name           = var.bastion_name
  bastion_ip_config_name = var.bastion_ip_config_name
  // Route Server Variables
  route_server_pip_name            = var.route_server_pip_name
  route_server_name                = var.route_server_name
  route_server_ip_config_name      = var.route_server_ip_config_name
  route_server_branch_to_branch    = var.route_server_branch_to_branch
  route_server_bgp_connection_name = var.route_server_bgp_connection_name
  peer_asn                         = var.peer_asn
  peer_ip                          = var.peer_ip
}