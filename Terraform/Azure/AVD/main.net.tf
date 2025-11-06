module "vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.10.0"
  address_space       = ["10.1.6.0/26"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnets = {
    subnet1 = {
      address_prefix = "10.1.6.0/27"
      name           = "avd-subnet-1"
    }
  }
}

# Deploy a single AVD session host using marketplace image
resource "azurerm_network_interface" "this" {
  count = var.vm_count

  location                       = azurerm_resource_group.this.location
  name                           = "${var.avd_vm_name}-${count.index}-nic"
  resource_group_name            = azurerm_resource_group.this.name
  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet.subnets["subnet-1"].id
  }
}