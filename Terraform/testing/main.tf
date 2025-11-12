terraform {
  required_version = "~> 1.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.21"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    
  }
  subscription_id = var.subscription_id
  use_oidc        = true
}

variable "subscription_id" {
  type = string
  description = "Azure Subscription to deploy into. Run $env:TF_VAR_subscription_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' to set the subscription id before running terraform plan command"
}

resource "azurerm_resource_group" "rg" {
  name     = "example-resources"
  location = "East US"
}

module "stg-mgmt" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.6"
  name = "stgflowmgmteus001"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  managed_identities = {
    system_assigned = true
  }
}

