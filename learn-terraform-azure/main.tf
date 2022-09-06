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

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
  tags = {
    Environemnt = "Terraform Getting Started"
    Team        = "ADO"
  }
}

# Create a Hub Vnet
resource "azurerm_virtual_network" "hubvnet" {
  name             = var.hubvnet_name
  address_space    = var.hubvnet_address_space
  location         = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet {
    name           = var.fw_subnet_name
    address_prefix = var.fw_address_prefix
  }
  subnet {
    name           = var.bastion_subnet_name
    address_prefix = var.bastion_address-prefix
  }
  subnet {
    name           = var.mgmt_subnet_name
    address_prefix = var.mgmt_address_prefix
  }
  tags = azurerm_resource_group.rg.tags
}

# Create a Spoke Vnet
resource "azurerm_virtual.network" "spokevnet" {

}