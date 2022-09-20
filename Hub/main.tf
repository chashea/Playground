# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Hub Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
  tags = {
    Environemnt = "Pre-Prod"
    Team        = "FTA"
  }
}

# Create a Hub Vnet
resource "azurerm_virtual_network" "hub-vnet" {
    name                = var.hubvnet_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
    tags = azurerm_resource_group.rg.tags
}

resource "azurerm_subnet" "bastion-sub" {
    name = var.bastion_sub
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub-vnet.name
    address_prefixes = ["10.0.0.0/26"]  
}

resource "azurerm_subnet" "fw-sub" {
    name = var.fw_sub
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub-vnet.name
    address_prefixes = [ "10.0.0.64/26" ]
}

resource "azurerm_subnet" "adds-sub" {
    name = var.adds_sub
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub-vnet.name
    address_prefixes = [ "10.0.0.128/27" ]
}

resource "azurerm_public_ip" "pip-bastion" {
  name = "pip-bastion"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"
  
}

#Create a Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name = var.bastion_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
  ip_configuration {
    name = "configuration"
    subnet_id = azurerm_subnet.bastion-sub.id
    public_ip_address_id = azurerm_public_ip.pip-bastion.id
   }
  }



#Create a Firewall