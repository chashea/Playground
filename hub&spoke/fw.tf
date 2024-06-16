module "fw_public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = ">=0.1.0"
  # insert the 3 required variables here
  name                = "pip-fw-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    deployment = "terraform"
  }
  zones = ["1", "2", "3"]
}


module "azfw" {
  source              = "Azure/avm-res-network-azurefirewall/azurerm"
  version             = ">=0.1.0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "azfw-eus2-001"
  firewall_sku_name   = "AZFW_VNet"
  firewall_sku_tier   = "Premium"
  firewall_zones      = ["1", "2", "3"]
  firewall_policy_id  = module.firewall_policy.resource.id
  firewall_ip_configuration = [
    {
      name                 = "ipconfig_fw"
      subnet_id            = azurerm_subnet.fw_subnet.id
      public_ip_address_id = module.fw_public_ip.public_ip_id
    }
  ]
  diagnostic_settings = {
    log = {
      log_groups                 = ["allLogs"]
      metric_categories              = ["AllMetrics"]
      workspace_resource_id          = module.law.resource.id
      log_analytics_destination_type = "Dedicated"
    }
  }
}

module "firewall_policy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"
  version             = ">=0.2.0"
  name                = "fw-policy-terraform"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  firewall_policy_sku = "Premium"
  firewall_policy_dns = {
    proxy_enabled = true
  }
  firewall_policy_threat_intelligence_mode = "Alert"
  tags = {
    deployment = "terraform"
  }
}

module "law" {
  source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version             = ">=0.2.0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "law-terraform"
}

