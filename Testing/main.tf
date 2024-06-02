terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = "1.13.1"
    }
  }
}

provider "azapi" {
}

resource "azapi_resource" "symbolicname" {
  type = "Microsoft.Billing/billingAccounts/invoiceSections@2018-11-01-preview"
  name = "string"
  parent_id = "string"
  body = jsonencode({
    properties = {
      billingProfiles = [
        {
          properties = {
            address = {
              addressLine1 = "string"
              addressLine2 = "string"
              addressLine3 = "string"
              city = "string"
              companyName = "string"
              country = "string"
              firstName = "string"
              lastName = "string"
              postalCode = "string"
              region = "string"
            }
            displayName = "string"
            enabledAzureSKUs = [
              {
                skuId = "string"
              }
            ]
            invoiceSections = [
              {
                properties = {}
            ]
            poNumber = "string"
          }
        }
      ]
      displayName = "string"
    }
  })
}