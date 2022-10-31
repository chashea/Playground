resource "azurerm_firewall_policy" "fw_policy" {
  name = "fw-policy-${var.resource_group_name}-${var.resource_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_firewall_policy_rule_collection_group" "FwPolicyRuleCollectionGroup" {
  name                = "fw-policy-rule-collection-group-${var.resource_group_name}-${var.resource_suffix}"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  priority            = 100
  
}
  
resource "azurerm_firewall_network_rule_collection" "FwNetRuleCollection" {
  name                = "fw-policy-network-rule-collection-${var.resource_group_name}-${var.resource_suffix}"
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"
  
}
  
