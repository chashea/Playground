module "law" {
  source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version             = "0.3.2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "law-terraform"
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
      private_dns_zone_resource_ids = [module.private_dns_zone.resource.id]
      network_interface_name        = "nic-pe-law"
    }
  }
}

