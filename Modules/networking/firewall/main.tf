resource "azurerm_firewall" "fw" {
  name = "azfw-${var.resource_suffix}-${var.resource_instance}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name = "AZFW_Hub"
  sku_tier = "Premium"
  firewall_policy_id = var.fw_policy_id
    ip_configuration {
        name = "configuration"
        subnet_id = var.fw_subnet_id
    }

tags = var.resource_tags
}

