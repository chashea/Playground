
locals {
  vnet_name        = "vnet-hub-${var.environment}-${var.location}"
  subnet_name      = "subnet-adds-${var.environment}-${var.location}"
  rg_name          = "rg-hub-net-${var.environment}-${var.location}"
  bastion_name     = "bastion-${var.environment}-${var.location}"
  bastion_pip_name = "pip-bastion-${var.environment}-${var.location}"
  fw_name          = "fw-hub-${var.environment}-${var.location}"
  fw_pip_name      = "pip-fw-${var.environment}-${var.location}"
  nsg_name         = "nsg-default-${var.environment}-${var.location}"
  nsg_rule_rdp_name = "nsg-rule-rdp-${var.environment}-${var.location}"
}