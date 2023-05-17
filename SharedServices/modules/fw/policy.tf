// Create a Parent Azure Firewall Policy
resource "azurerm_firewall_policy" "fw_policy" {
  name                = local.fw_policy_name
  resource_group_name = local.rg_name
  location            = azurerm_resource_group.rg_fw.location
  tags                = azurerm_resource_group.rg_fw.tags
  depends_on = [
    azurerm_resource_group.rg_fw
  ]
}
