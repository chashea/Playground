// Create a Resource Group for the Virtual Network and Subnet
resource "azurerm_resource_group" "rg_net" {
  name     = "rg-net-${var.location}-${var.environment}"
  location = var.location
  tags     = var.tags

}

// Create a Virtual Network with a single subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.location}-${var.environment}"
  address_space       = ["10.11.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_net.name
  tags                = var.tags
}
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.location}-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg_net.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.11.0.0/26"]
}

// Create a Subnet for AVD
resource "azurerm_subnet" "avd_subnet" {
  name                 = "avd-subnet-${var.location}-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg_net.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.11.1.0/24"]
}

// Create Azure Bastion Subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_net.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.11.2.0/24"]
}

// Create Public IP for Azure Bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.rg_net.location
  resource_group_name = azurerm_resource_group.rg_net.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = azurerm_resource_group.rg_net.tags
}