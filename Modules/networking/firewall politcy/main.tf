data "azurerm_firewall_policy" "fw_policy" {
  name                = var.fw_policy_name
  resource_group_name = var.resource_group_name
}

