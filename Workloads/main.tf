provider "azurerm" {
  features {}
}

module "vnet" {
  source               = "./Modules/vnet"
  location             = var.location
  environment          = var.environment
  tags                 = var.tags
  vnet_address_space   = var.vnet_address_space
  subnet_address_space = var.subnet_address_space

}

module "dse" {
  source      = "./Modules/dse"
  location    = var.location
  environment = var.environment
  tags        = var.tags
}

module "vm" {
  source                 = "./Modules/vm"
  location               = var.location
  environment            = var.environment
  tags                   = var.tags
  subnet_id              = module.vnet.subnet_id
  disk_encryption_set_id = module.kv.dse_id
  admin_password         = var.admin_password
  admin_username         = var.admin_username
  vm_size                = var.vm_size
}