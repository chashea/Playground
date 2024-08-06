
terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

resource "azurerm_resource_group" "rg" {
 name = "azure-resources"
    location = "East US" 
}

module "hub_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "hub-vnet"
  address_space       = ["10.200.0.0/16"]
  subnets = {
    subnet0 = {
      name           = "AzureFirewallSubnet"
      address_prefix = "10.200.0.0/26"
    }
    subnet1 = {
      name           = "AzureBastionSubnet"
      address_prefix = "10.200.0.64/26"
    }
    subnet2 = {
      name           = "GatewaySubnet"
      address_prefix = "10.200.1.0/27"
    }
  }
}
