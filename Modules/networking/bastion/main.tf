resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  resource_group_name = var.rg_name
  location            = var.rg_location
}
resource "azurerm_public_ip" "bastion_pip" {
  name                = var.bastion_public_ip_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = var.bastion_public_ip_sku
  allocation_method   = var.bastion_public_ip_allocation_method
  tags                = var.rg_tags
}



resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.hub_net
  address_prefixes     = [var.bastion_subnet_address_prefix]
}
