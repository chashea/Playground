# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = var.virtual_network_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

# Create Azure Virtual Network and Subnet
module vnet_subnet {
  source = "../vnet_subnet"
  for_each = var.subnets
  
  name                            = each.value.name
  virtual_network_name            = azurerm_virtual_network.vnet.name
  resource_group_name             = azurerm_virtual_network.vnet.resource_group_name
  subnet_address_prefix           = each.value.address_prefix
}