resource "azurerm_firewall_policy" "fw_policy" {
  name = "fw-policy-${var.resource_group_name}-${var.resource_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}


resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_rule_collection_group" {
  name = "fw-policy-rule-collection-group-${var.resource_group_name}-${var.resource_suffix}"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100
}

resource "azurerm_firewall_network_rule_collection" "fw_policy_network_rule_collection" {
  name                = "NetworkRules-AVD"
  priority            = 100
  action               = "Allow"
  azure_firewall_name = var.fw_name
  resource_group_name = var.resource_group_name
  rule {
    name = "Service Traffic"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["443"]
    source_addresses = ["*"]
    destination_addresses = ["WindowsVirtualDesktop"]
  }
  rule {
    name = "Agent Traffic"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["443"]
    source_addresses = ["*"]
    destination_addresses = ["AzureMonitor"]
  }
  rule {
    name = "Azure Marketplace"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["443"]
    source_addresses = ["*"]
    destination_addresses = ["AzureFrontDoor.Frontend"]
  }
  rule {
    name = "Windows Activation"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["1688"]
    source_addresses = ["*"]
    destination_addresses = ["kms.core.windows.net"]
  }
  rule {
    name = "Auth to Msft Online Services"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["443"]
    source_addresses = ["*"]
    destination_addresses = ["login.microsoftonline.com	"]
  }

  rule {
    name = "Azure Windows Activation"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["1688"]
    source_addresses = ["*"]
    destination_addresses = ["azkms.core.windows.net"]
  }
  rule {
    name = "Agent and SxS Stack Updates"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["443"]
    source_addresses = ["*"]
    destination_addresses = ["mrsglobalsteus2prod.blob.core.windows.net"]
  }
  rule {
    name = "Azure Portal Support"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["443"]
    source_addresses = ["*"]
    destination_addresses = ["wvdportalstorageblob.blob.core.windows.net"]
  }
  rule {
    name = "Azure Instance Metadata Service Endpoint"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["80"]
    source_addresses = ["*"]
    destination_addresses = ["169.254.169.254"]
  }
  rule {
    name = "Session Host Health Monitoring"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["80"]
    source_addresses = ["*"]
    destination_addresses = ["168.63.129.16"]
  }
  rule {
    name = "Cert CRL OneOCSP"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["80"]
    source_addresses = ["*"]
    destination_addresses = ["oneocsp.microsoft.com"]
  }
  rule {
    name = "Cert CRL MicrosoftDotCom"
    protocols = {
      type = "TCP"
    }
    destination_ports = ["80"]
    source_addresses = ["*"]
    destination_addresses = ["www.microsoft.com"]
  }


}