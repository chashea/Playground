// Create a nic for the VM

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.location}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}