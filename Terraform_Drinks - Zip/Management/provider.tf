terraform {
  required_version = "~> 0.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.50.0"
    }
  }
  backend "azurerm" {
  }  
}

# Configure the Microsoft Azure Provider
#provider "azurerm" {
#  features {}
#}
