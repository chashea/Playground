resource "azurerm_resource_group" "rg_law" {
  name     = "${module.naming.resource_group.name_unique}-workspace"
  location = "eastus2"
}

// Deploy Private DNS Zone
module "privatednszone_law" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "0.1.2"
  resource_group_name = azurerm_resource_group.rg_law.name
  domain_name         = "privatelink.workspace.azure.net"
  virtual_network_links = {
    vnetlink0 = {
      vnetlinkname = "dnslinktovnet001"
      vnetid       = module.hub_vnet.resource.id
    }
  }
  tags = {
    deployment = "terraform"
  }
}


module "law" {
  source                                    = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version                                   = "0.3.2"
  location                                  = azurerm_resource_group.rg_law.location
  resource_group_name                       = azurerm_resource_group.rg_law.name
  name                                      = module.naming.log_analytics_workspace.name_unique
  log_analytics_workspace_retention_in_days = 30
  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_identity = {
    type = "SystemAssigned"
  }
  monitor_private_link_scope = {
    scope0 = {
      name                  = "law_pl_scope"
      ingestion_access_mode = "PrivateOnly"
      query_access_mode     = "PrivateOnly"
    }
  }
  monitor_private_link_scoped_service_name = "law_pl_service"
  private_endpoints = {
    pe1 = {
      name                          = module.naming.private_endpoint.name_unique
      subnet_resource_id            = module.hub_vnet.subnets["subnet3"].resource.id
      private_dns_zone_resource_ids = [module.privatednszone_law.resource.id]
      network_interface_name        = "nic-pe-law"
    }
  }
}

