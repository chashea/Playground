resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

module "vnet_nsg_rule" {
  source = "../vnet_nsg_rule"
  for_each = var.nsg_rules

  rule_name                   = each.value.rule_name
  priority                    = each.value.priority
  access                      = each.value.access
  direction                   = each.value.direction
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}