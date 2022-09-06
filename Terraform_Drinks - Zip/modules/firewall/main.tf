data "azurerm_subnet" "subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}

data "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_firewall" "fw" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  #ip_configuration    = var.ip_configuration
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.subnet.id
    public_ip_address_id = data.azurerm_public_ip.public_ip.id
  }
}

module "firewall_network_rule" {
  source = "../firewall_network_rule"
  for_each = var.firewall_network_rule

  firewall_rule_collection_name = each.value.firewall_rule_collection_name
  azure_firewall_name           = azurerm_firewall.fw.name
  resource_group_name           = azurerm_firewall.fw.resource_group_name
  priority                      = each.value.priority
  action                        = each.value.action
  network_rules                 = each.value.network_rules
}