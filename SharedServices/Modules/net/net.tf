// Create a Virtual Network and Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = local.rg_name
  tags                = azurerm_resource_group.rg.tags
  depends_on = [
    azurerm_resource_group.rg
  ]
}

// Create a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_name
  address_prefixes     = var.subnet_address_prefixes
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_network.vnet

  ]
}


