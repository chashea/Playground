data "azurerm_client_config" "current" {}

module "resource_groups" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.0"
  for_each         = local.resource_groups
  location         = each.value.location
  name             = each.value.name
  enable_telemetry = false
  tags             = local.common_tags
}

resource "random_string" "suffix" {
  length  = 4
  numeric = true
  special = false
  upper   = false
}

module "rt-app" {
  source              = "Azure/avm-res-network-routetable/azurerm"
  version             = "0.4.1"
  name                = "rt-app-conn-eus-${random_string.suffix.result}-001"
  location            = local.resource_groups["app_conn"].location
  resource_group_name = module.resource_groups["app_conn"].name
  subnet_resource_ids = {
    subnet01 = module.vnet-app.subnets["subnet01"].resource_id
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
  location            = local.resource_groups["app_conn"].location
  resource_group_name = local.resource_groups["app_conn"].name
}

module "vnet-app" {
  source        = "Azure/avm-res-network-virtualnetwork/azurerm"
  version       = "0.15.0"
  location      = local.resource_groups["app_conn"].location
  parent_id     = module.resource_groups["app_conn"].resource_id
  address_space = ["10.100.0.0/16"]
  name          = "vnet-app-conn-eus-${random_string.suffix.result}-001"
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

module "kv-mgmt" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"
  name = "kv-app-eus-001"
  resource_group_name = local.resource_groups["app_conn"].name
  location = local.resource_groups["app_conn"].location
  tenant_id = data.azurerm_client_config.current.tenant_id
}

