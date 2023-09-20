
locals {
  vnet_name         = "vnet-hub-${var.prefix}-${var.environment}-${var.location}"
  subnet_name       = "subnet-adds-${var.prefix}-${var.environment}-${var.location}"
  rg_name           = "rg-hub-net-${var.prefix}-${var.environment}-${var.location}"
  nsg_name          = "nsg-default-${var.prefix}-${var.environment}-${var.location}"
  nsg_rule_rdp_name = "nsg-rule-rdp-${var.prefix}-${var.environment}-${var.location}"
}

// Create a Resource Group for Hub Virtual Network
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

// Create a Virtual Network and Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = local.rg_name
  tags                = azurerm_resource_group.rg.tags
  address_space       = var.vnet_address_space
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

// Create a default NSG
resource "azurerm_network_security_group" "nsg" {
  name                = local.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = local.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

// Create a NSG Rule to allow RDP
resource "azurerm_network_security_rule" "nsg_rule_rdp" {
  name                        = local.nsg_rule_rdp_name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  depends_on = [
    azurerm_network_security_group.nsg
  ]
}

// Associate the NSG to the Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.subnet,
    azurerm_network_security_group.nsg
  ]
}