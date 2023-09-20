// Create Locals for Virtual Network, Subnet, Peerings
locals {
  vnet_name           = "vnet-spoke-${var.location}-${var.environment}"
  subnet_name         = "subnet-${var.location}-${var.environment}"
  rg_name             = "rg-spoke-net-${var.location}-${var.environment}"
  vnet_peering_name_1 = "vnet-peering-001-${var.location}-${var.environment}"
  vnet_peering_name_2 = "vnet-peering-002${var.location}-${var.environment}"
}

