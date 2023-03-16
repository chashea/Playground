provider "azurerm" {
  features {}
}

module "vnet" {
  source      = "./Modules/vnet"
  location    = "eastus"
  environment = "dev"
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}

module "kv" {
  source      = "./Modules/kv"
  location    = "eastus"
  environment = "dev"
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}

module "vm" {
  source      = "./Modules/vm"
  location    = "eastus"
  environment = "dev"
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
  subnet_id = module.vnet.subnet_id
  disk_encryption_set_id = module.kv.dse_id
}