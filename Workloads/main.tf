provider "azurerm" {
  features {}
}

module "vnet" {
  source      = "./Modules/vnet"
  location    = var.location
  environment = var.environment
  tags        = var.tags
}
/*module "vm" {
  source                 = "./Modules/vm"
  location               = var.location
  environment            = var.environment
  tags                   = var.tags
  subnet_id              = module.vnet.subnet_id
  disk_encryption_set_id = module.dse.dse_id
}*/
module "law" {
  source      = "./Modules/law"
  location    = var.location
  environment = var.environment
  tags        = var.tags
  prefix      = var.prefix
}

/*module "dse" {
  source      = "./Modules/dse"
  location    = var.location
  environment = var.environment
  tags        = var.tags
  prefix      = var.prefix
}*/

