// Create Public IP Address for Bastion

resource "azurerm_public_ip" "bastion_pip" {
  name                = var.bastion_pip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

// Create Bastion

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                 = var.bastion_ip_config_name
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

