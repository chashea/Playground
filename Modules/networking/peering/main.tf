resource "azurerm_virtual_network_peering" "hub" {
  name                                = var.hub_peering_name
  resource_group_name                 = var.rg_name
  virtual_network_name                = var.hub_net_name
  remote_virtual_network_id           = var.spoke_net_id
}

  resource "azurerm_virtual_network_peering" "spoke" {
    name                              = var.spoke_net_name
    resource_group_name               = var.rg_name
    virtual_network_name              = var.spoke_net_name
    remote_virtual_network_id         = var.hub_net_id
}

