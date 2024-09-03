data "azurerm_client_config" "current" {}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
}

resource "azurerm_resource_group" "rg_hub" {
  name     = "${module.naming.resource_group.name_unique}-hub"
  location = "eastus2"
}


// Deploy Hub Virtual Network
module "hub_vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.4.0"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = azurerm_resource_group.rg_hub.location
  name                = "${module.naming.virtual_network.name_unique}-hub"
  address_space       = ["10.200.0.0/16"]
  subnets = {
    subnet0 = {
      name           = "AzureFirewallSubnet"
      address_prefix = "10.200.0.0/26"
    }
    subnet1 = {
      name           = "AzureBastionSubnet"
      address_prefix = "10.200.0.64/26"
    }
    subnet2 = {
      name           = "GatewaySubnet"
      address_prefix = "10.200.1.0/27"
    }
    subnet3 = {
      name           = "pe-${module.naming.subnet.name_unique}"
      address_prefix = "10.200.2.0/24"
    }
    subnet4 = {
      name           = "adds-${module.naming.subnet.name_unique}"
      address_prefix = "10.200.0.128/29"
    }
    subnet5 = {
      name           = "mgmt-${module.naming.subnet.name_unique}"
      address_prefix = "10.200.0.192/29"
    }
  }
}

// Deploy Firewall Resources
module "fw_public_ip" {
  source              = "Azure/avm-res-network-publicipaddress/azurerm"
  version             = "0.1.0"
  name                = "${module.naming.public_ip.name_unique}-fw"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    deployment = "terraform"
  }
  zones = ["1", "2", "3"]
}


module "azfw" {
  source              = "Azure/avm-res-network-azurefirewall/azurerm"
  version             = "0.2.2"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = azurerm_resource_group.rg_hub.location
  name                = module.naming.firewall.name_unique
  firewall_sku_name   = "AZFW_VNet"
  firewall_sku_tier   = "Premium"
  firewall_zones      = ["1", "2", "3"]
  firewall_policy_id  = module.firewall_policy.resource.id
  firewall_ip_configuration = [
    {
      name                 = "ipconfig_fw"
      subnet_id            = module.hub_vnet.subnets["subnet0"].resource.id
      public_ip_address_id = module.fw_public_ip.public_ip_id
    }
  ]
  diagnostic_settings = {
    log = {
      workspace_resource_id          = module.law.resource.id
      log_analytics_destination_type = "Dedicated"
      name                           = "fw-dia-01"
    }
  }
  tags = {
    deployment = "terraform"
  }
}

module "firewall_policy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"
  version             = "0.2.3"
  name                = module.naming.firewall_policy.name_unique
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = azurerm_resource_group.rg_hub.location
  firewall_policy_sku = "Premium"
  firewall_policy_dns = {
    proxy_enabled = true
  }
  firewall_policy_threat_intelligence_mode = "Alert"
  tags = {
    deployment = "terraform"
  }
}

// Deploy Bastion Resource
module "bastion" {
  source              = "Azure/avm-res-network-bastionhost/azurerm"
  version             = "0.3.0"
  name                = "bastion-${module.naming.bastion_host.name_unique}"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  ip_configuration = {
    name                 = "ipconfig-${module.naming.bastion_host.name_unique}"
    subnet_id            = module.hub_vnet.subnets["subnet1"].resource.id
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
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    deployment = "terraform"
  }
  zones = ["1", "2", "3"]
}

// Deploy Jump Box
module "jb" {
  source              = "Azure/avm-res-compute-virtualmachine/azurerm//examples/default"
  version             = "0.15.1"
  name                = "${module.naming.virtual_machine.name_unique}-jb"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = azurerm_resource_group.rg_hub.location
  admin_password      = "Password1234!"
  sku_size            = "Standard_D2ds_v5"
  zone                = ["1", "2", "3"]
  network_interfaces = {
    nic0 = {
      name = "${module.naming.network_interface.name_unique}jb"
      ip_configuration = {
        name                          = "ipconfig-${module.naming.network_interface.name_unique}"
        private_ip_subnet_resource_id = module.hub_vnet.subnets["subnet5"].resource.id
        private_ip_address_allocation = "Dynamic"
      }

    }
  }
  os_disk = {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }
  tags = {
    deployment = "terraform"
  }
}