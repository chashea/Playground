resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip-${var.resouce_suffix}-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.resource_tags
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.hub_net
  address_prefixes     = [x.x.x.x.x/x]
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-${var.resouce_suffix}-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku = "Standard"
    ip_configuration {
        name                 = "bastion-ip-configuration"
        subnet_id            = azurerm_subnet.bastion_subnet.id
        public_ip_address_id = azurerm_public_ip.bastion_pip.id
    }
  tags = var.resource_tags
  file_copy_enabled = "true" 
  scale_units = 4
}


