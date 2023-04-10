// Create Locals for Hub Virtual Network, Subnet and Resource Group
locals {
  vnet_name   = "vnet-hub-${var.environment}-${var.location}"
  subnet_name = "subnet-adds-${var.environment}-${var.location}"
  rg_name     = "rg-hub-net-${var.environment}-${var.location}"
}
