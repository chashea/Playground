module "private_dns_zone" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "0.1.2"
  resource_group_name = azurerm_resource_group.rg.name
  domain_name         = "sheadomain.com"
  tags = {
    deployment = "terraform"
  }
}