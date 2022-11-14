# Firewall is already created in the environment
data "azurerm_virtual_network" "name" {
  name                = var.vnet
  resource_group_name = var.resource_group_name
}

# Creating the networking pieces for the firewall
resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.name.name
  address_prefixes     = ["10.0.0.64/26"]
}

resource "azurerm_public_ip" "azfwpip" {
  name                = "azfwpip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.resource_tags
}


# Creating the firewall
resource "azurerm_firewall" "azfw" {
  name                = var.fw_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.azfwpip.id
  }
  firewall_policy_id = var.fw_policy_id
}