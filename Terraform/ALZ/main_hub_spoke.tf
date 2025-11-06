module "resource_groups" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.0"
  for_each = local.resource_groups
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

module "alz" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "0.15.0"
  default_naming_convention = {
    virtual_network_name = "vnet-hub-primary-${random_string.suffix.result}"
  }
  enable_telemetry = false
  hub_and_spoke_networks_settings = {
    enabled_resources = {
      ddos_protection_plan = false
    }
  }
  hub_virtual_networks = {
    primary_hub = {
      enabled_resources = {
        private_dns_zones                     = false
        private_dns_resolvers                 = false
        virtual_network_gateway_express_route = false
      }
      location                  = local.resource_groups["hub_primary"].location
      default_parent_id         = module.resource_groups["hub_primary"].resource_id
      default_hub_address_space = "10.0.0.0/16"
      
    }
  }
  tags = local.common_tags
}