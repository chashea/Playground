// Create Azure Firewall Parent Policy

resource "azurerm_firewall_policy" "fw_parent_policy" {
  name                = var.fw_parent_policy_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
