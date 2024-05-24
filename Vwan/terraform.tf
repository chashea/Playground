terraform {
  required_version = ">= 1.3.0"
  backend "azurerm" {
    resource_group_name = "rg-terraform-state"
    storage_account_name = "terraformbackendstg"
    container_name = "terraformbackend"
    key = "vwan.tfstate"

  }
  required_providers {
    # TODO: Ensure all required providers are listed here.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
  }
}

provider "azurerm" {
  alias = "vwan"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}