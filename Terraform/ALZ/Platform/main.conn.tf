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

module "alznetwork" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "0.15.0"
  default_naming_convention = {
    virtual_network_name = "vnet-hub-conn-${random_string.suffix.result}-001"
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
        virtual_network_gateway_express_route = false
      }
      location                  = local.resource_groups["hub_conn"].location
      default_parent_id         = module.resource_groups["hub_conn"].resource_id
      default_hub_address_space = "10.0.0.0/16"
      firewall = {
        management_ip_enabled = false
        name = "fw-hub-conn-eus-001"
      }
      virtual_network_gateways = {
        vpn = { 
          parent_id = module.resource_groups["hub_conn"].resource_id
          name      = "vng-hub-conn-vpn-001"
          vpn_active_active_enabled = false
          ip_configurations = {
            ipconfig01 = {
              name = "vpnipconfig"
            }
          }
        }
      }
      firewall_policy = {
        name = "fwpolicy-hub-conn-eus-001"
        insights = {
          enabled = true
          default_log_analytics_workspace_id = module.law-mgmt.log_analytics_workspace.id
        }
      }
      private_dns_zones = {
        
          }
        }
      }
   tags = local.common_tags
}


module "avm-res-network-firewallpolicy_rule_collection_groups" {
  source  = "Azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  version = "0.3.3"
  firewall_policy_rule_collection_group_firewall_policy_id = module.alznetwork.firewall_policies["primary_hub"].id
  firewall_policy_rule_collection_group_name = "fcg-hub-conn-eus-001"
  firewall_policy_rule_collection_group_priority = 1000
    firewall_policy_rule_collection_group_network_rule_collection = [
    {
      action   = "Allow"
      name     = "NetworkRuleCollection"
      priority = 400
      rule = [
        {
          name                  = "Azure_to_All_Allowed"
          destination_addresses = ["*"]
          destination_ports     = ["*"]
          source_addresses      = ["*"]
          protocols             = ["TCP", "UDP", "ICMP"]
        }
      ]
    }
  ]
  firewall_policy_rule_collection_group_application_rule_collection = [
    {
      action   = "Allow"
      name     = "ApplicationRuleCollection"
      priority = 600
      rule = [
        {
          name             = "AllowAll"
          description      = "Allow all outbound Internet traffic"
          source_addresses = ["*"]
          protocols = [
            {
              port = 443
              type = "Https"
            }
          ]
          destination_fqdns = ["*"]
        }
      ]
    }
  ]
}


