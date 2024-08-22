module "private_dns_zone" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "0.1.2"
  resource_group_name = azurerm_resource_group.rg_hub.name
  domain_name         = "sheadomain.com"
  virtual_network_links = {
    vnetlink0 = {
      vnetlinkname = "dnslinktovnet"
      vnetid       = module.hub_vnet.resource.id
    }
  }
  tags = {
    deployment = "terraform"
  }
}

