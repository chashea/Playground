data "azurerm_firewall" "azfw" {
  name                = var.fw_name
  resource_group_name = var.resource_group_name
}