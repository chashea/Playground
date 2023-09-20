locals {
  bastion_name     = "bastion-${var.prefix}-${var.environment}-${var.location}"
  pip_bastion_name = "pip-bastion-${var.prefix}-${var.environment}-${var.location}"
  rg_name          = "rg-hub-bastion-${var.prefix}-${var.environment}-${var.location}"
}

// Create a Resource Group for Bastion Host
resource "azurerm_resource_group" "rg_bastion" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

// Create a Public IP for Bastion Host
resource "azurerm_public_ip" "bastion_pip" {
  name                = local.pip_bastion_name
  resource_group_name = local.rg_name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = azurerm_resource_group.rg.tags
}

// Create a Subnet for Bastion Host
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.bastion_subnet
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
  tags              = azurerm_resource_group.rg.tags
  file_copy_enabled = "true"
}


