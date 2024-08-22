
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
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
}

resource "azurerm_resource_group" "rg_stg" {
  name     = "${module.naming.resource_group.name_unique}-stg"
  location = "eastus2"
}

module "stg" {
  source                   = "Azure/avm-res-storage-storageaccount/azurerm"
  version                  = "0.2.3"
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.rg_stg.name
  location                 = azurerm_resource_group.rg_stg.location
  account_tier             = "Premium"
  account_replication_type = "ZRS"
  shared_access_key_enabled = false
  account_kind = "FileStorage"
  default_to_oauth_authentication = true

}