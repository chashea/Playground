// Create a Public IP for Bastion Host
resource "azurerm_public_ip" "bastion_pip" {
  name                = local.bastion_pip_name
  resource_group_name = local.rg_name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = azurerm_resource_group.rg.tags

  depends_on = [
    azurerm_resource_group.rg
  ]
}
// Create a Subnet for Bastion Host
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_name
  address_prefixes     = var.bastion_subnet
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_network.vnet
  ]
}

// Create a Bastion Host
resource "azurerm_bastion_host" "bastion_host" {
  name                = local.bastion_name
  resource_group_name = local.rg_name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  ip_configuration {
    name                 = "bastion-ip-configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
  tags              = var.tags
  file_copy_enabled = "true"
  scale_units       = 4
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_subnet.bastion_subnet,
    azurerm_public_ip.bastion_pip
  ]
}


