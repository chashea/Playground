// Create an Azure Bastion Host
resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-host"
  location            = azurerm_resource_group.rg_net.location
  resource_group_name = azurerm_resource_group.rg_net.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
  depends_on = [
    azurerm_subnet.bastion_subnet,
    azurerm_public_ip.bastion_public_ip
  ]
}