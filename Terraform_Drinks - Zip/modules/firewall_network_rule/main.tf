resource "azurerm_firewall_network_rule_collection" "rule_collection" {
  name                = var.firewall_rule_collection_name
  azure_firewall_name = var.azure_firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = var.action

  dynamic "rule" {
      for_each = var.network_rules
      content {
        name                  = rule.value.rule_name
        description           = rule.value.description
        source_addresses      = rule.value.source_addresses
        #source_ip_groups      = rule.value.source_ip_groups
        destination_addresses = rule.value.destination_addresses
        #destination_ip_groups = rule.value.["destination_ip_groups"]
        destination_ports     = rule.value.destination_ports
        protocols             = rule.value.protocols
      }
  }
  #rule {
  #  name = "testrule"
  #  source_addresses = [
  #    "10.0.0.0/16",
  #  ]
  #  destination_ports = [
  #    "53",
  #  ]
  #  destination_addresses = [
  #    "8.8.8.8",
  #    "8.8.4.4",
  #  ]
  #  protocols = [
  #    "TCP",
  #    "UDP",
  #  ]
  #}  
}