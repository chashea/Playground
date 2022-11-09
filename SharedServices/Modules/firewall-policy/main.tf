resource "azurerm_firewall_policy" "fw_policy" {
  name                = "AVD-FW-Policy"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  tags                = var.resource_tags
}
resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_rule_collection_group" {
  name               = "AVD-FW-RCG"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100

  ### Required Network Rules for AVD
  network_rule_collection {
    name     = "AVD-Network-Rule-Collection"
    priority = 100
    action   = "Allow"
    rule {
      name = "Service Traffic"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["443"]
      source_addresses      = ["*"]
      destination_addresses = ["WindowsVirtualDesktop"]
    }
    rule {
      name = "Agent Traffic"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["443"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureMonitor"]
    }
    rule {
      name = "Azure Marketplace"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["443"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureFrontDoor.Frontend"]
    }
    rule {
      name = "Windows Activation"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["1688"]
      source_addresses      = ["*"]
      destination_addresses = ["kms.core.windows.net"]
    }
    rule {
      name = "Auth to Msft Online Services"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["443"]
      source_addresses      = ["*"]
      destination_addresses = ["login.microsoftonline.com	"]
    }

    rule {
      name = "Azure Windows Activation"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["1688"]
      source_addresses      = ["*"]
      destination_addresses = ["azkms.core.windows.net"]
    }
    rule {
      name = "Agent and SxS Stack Updates"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["443"]
      source_addresses      = ["*"]
      destination_addresses = ["mrsglobalsteus2prod.blob.core.windows.net"]
    }
    rule {
      name = "Azure Portal Support"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["443"]
      source_addresses      = ["*"]
      destination_addresses = ["wvdportalstorageblob.blob.core.windows.net"]
    }
    rule {
      name = "Azure Instance Metadata Service Endpoint"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["80"]
      source_addresses      = ["*"]
      destination_addresses = ["169.254.169.254"]
    }
    rule {
      name = "Session Host Health Monitoring"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["80"]
      source_addresses      = ["*"]
      destination_addresses = ["168.63.129.16"]
    }
    rule {
      name = "Cert CRL OneOCSP"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["80"]
      source_addresses      = ["*"]
      destination_addresses = ["oneocsp.microsoft.com"]
    }
    rule {
      name = "Cert CRL MicrosoftDotCom"
      protocols = {
        type = "TCP"
      }
      destination_ports     = ["80"]
      source_addresses      = ["*"]
      destination_addresses = ["www.microsoft.com"]
    }
  }

  ### Required Application Rules for AVD
  application_rule_collection {
    name     = "AVD-Application-Rule-Collection"
    priority = 100
    action   = "Allow"

    rule {
      name = "TelemetryService"
      protocols = {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["*.events.data.microsoft.com"]
    }
    rule {
      name = "Windows Update"
      protocols = {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["*.sfx.ms"]
    }
    rule {
      name = "UpdatesforOneDrive"
      protocols = {
        type = "Https"
        port = 443
      }
      source_addresses       = ["*"]
      destination_fqdns_tags = ["WindowsUpdate"]
    }
    rule {
      name = "DigitcertCRL"
      protocols = {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["*.digicert.com"]
    }
    rule {
      name = "AzureDNSResolution"
      protocols = {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["*.azure-dns.com"]
    }
    rule {
      name = "AzureDNSresolution2"
      protocols = {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["*.azure-dns.net"]
    }
  }
}