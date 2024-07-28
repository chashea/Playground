module "bastion" {
  source              = "Azure/avm-res-network-bastionhost/azurerm"
  version             = "0.3.0"
  name                = module.naming.bastion_host.name_unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration = {
    name                 = "ipconfig-${module.naming.bastion_host.name_unique}"
    subnet_id            = module.hub_vnet.subnets["subnet1"].id
    public_ip_address_id = module.pip_bastion.public_ip_id
  }
  tags = {
    deployment = "terraform"
  }
}

module "pip_bastion" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"
  # insert the 3 required variables here
  name                = "${module.naming.public_ip.name_unique}-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    deployment = "terraform"
  }
  zones = ["1", "2", "3"]
}