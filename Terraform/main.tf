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
  hub_vnet_name = var.hub_vnet_name
  // Firewall Variables
  fw_pip_name           = var.fw_pip_name
  fw_name               = var.fw_name
  fw_ip_config_name     = var.fw_ip_config_name
  fw_parent_policy_name = var.fw_parent_policy_name
  // Bastion Variables
  bastion_pip_name       = var.bastion_pip_name
  bastion_name           = var.bastion_name
  bastion_ip_config_name = var.bastion_ip_config_name
  // Virtual WAN Variables
  vwan_name = var.vwan_name
  vhub_name = var.vhub_name
  // Virtual Network Gateway Variables
  vng_name           = var.vng_name
  vng_sku            = var.vng_sku
  vng_ip_config_name = var.vng_ip_config_name
  vng_pip_name       = var.vng_pip_name

  // Local Network Gateway Variables
  lng_name          = var.lng_name
  lng_address_space = var.lng_address_space
}

module "avd" {
  source       = "./avd"
  rg_avd_name  = var.rg_avd_name
  avd_location = var.avd_location
  // VNet Variables
  avd_vnet_name        = var.avd_vnet_name
  personal_subnet_name = var.personal_subnet_name
  pooled_subnet_name   = var.pooled_subnet_name
  avd_vnet_peering     = var.avd_vnet_peering
  hub_vnet_id          = module.hub.hub_vnet_id
  hub_rg_name          = module.hub.rg_hub_name
  hub_vnet_name        = module.hub.hub_vnet_name
  vnet_avd_peering     = var.vnet_avd_peering
  // AVD Variables
  pooled_name            = var.pooled_name
  pooled_dag_name        = var.pooled_dag_name
  personal_hostpool_name = var.personal_hostpool_name
  personal_dag_name      = var.personal_dag_name
  workspace_name         = var.workspace_name
}