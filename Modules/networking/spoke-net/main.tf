resource "azurerm_virtual_network" "spoke_net_name" {
    name                = var.spoke_net_name
    resource_group_name = var.rg_name
    location            = var.rg_location
    address_space       = [var.spoke_net_address_space]
    tags                = var.rg_tags
}

resource "azurerm_subnet" "spoke_net_subnet" {
    name                 = var.spoke_net_subnet_name
    resource_group_name  = var.rg_name
    virtual_network_name = azurerm_virtual_network.spoke_net_name.name
    address_prefixes     = [var.spoke_subnet_address_prefix]
}

