// Create a Public IP Address for Virtual Network Gateway
resource "azurerm_public_ip" "vng_pip" {
  name                = var.vng_pip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

// Create a Virtual Network Gateway for Hub Network
resource "azurerm_virtual_network_gateway" "vng" {
  name                = var.vng_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.vng_sku
  type                = "Vpn"
  ip_configuration {
    name                          = var.vng_ip_config_name
    public_ip_address_id          = azurerm_public_ip.vng_pip.id
    subnet_id                     = azurerm_subnet.gateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

// Create a Local Network Gateway for Gateway Connection

resource "azurerm_local_network_gateway" "lng" {
  name                = var.lng_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  gateway_address     = azurerm_public_ip.vng_pip.ip_address
  address_space       = var.lng_address_space
}

