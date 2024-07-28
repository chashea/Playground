terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "terraformbackendstg"
    container_name       = "terraformbackend"
    key                  = "hubspoke.tfstate"
    tenant_id            = "5c5e1a56-251f-44b1-8f67-c97243f9e7cb"
    subscription_id      = "9e087dff-9c5b-4650-96ee-19cfe5269c5d"
  }
}