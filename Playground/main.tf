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
    Environemnt = "Pre-Prod"
    Team        = "FTA"
  }
}

# Create a Hub Vnet
resource "azurerm_virtual_network" "hubvnet" {
  name             = var.hubvnet_name
  address_space    = var.hubvnet_address_space
  location         = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = azurerm_resource_group.rg.tags
}




