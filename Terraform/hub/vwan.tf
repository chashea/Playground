// Create Virtual WAN resources

resource "azurerm_virtual_wan" "vwan" {
  name                = var.vwan_name
  location            = var.location
  resource_group_name = var.rg_hub_name
}

resource "azurerm_virtual_hub" "vhub" {
  name                = var.vhub_name
  location            = var.location
  resource_group_name = var.rg_hub_name
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.1.0.0/24"
}