data "azurerm_firewall" "name" {
  name                = var.fw_name
  resource_group_name = var.resource_group_name
}
