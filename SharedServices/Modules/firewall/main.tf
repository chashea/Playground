resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.hub_net_name
  address_prefixes     = ["10.1.0.64/26"]
}

resource "azurerm_public_ip" "fw_pip" {
  name                = "fw-pip-${var.resouce_suffix}-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_firewall" "fw" {
  name                = "azfw-${var.resource_suffix}-${var.resource_instance}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  zones               = ["1,2,3"]

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }

  tags               = var.resource_tags
  firewall_policy_id = var.fw_policy_id


}

