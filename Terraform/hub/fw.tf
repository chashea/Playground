// Create Azure Firwall Public IP Address

resource "azurerm_public_ip" "fw_pip" {
  name                = var.fw_pip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

// Create Azure Firewall

resource "azurerm_firewall" "fw" {
  name                = var.fw_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_tier            = var.fw_sku_tier
  sku_name            = var.fw_sku_name

  ip_configuration {
    name                 = var.fw_ip_config_name
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}

