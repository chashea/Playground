
locals {
  vnet_name        = "vnet-hub-${var.prefix}-${var.environment}-${var.location}"
  subnet_name      = "subnet-adds-${var.prefix}-${var.environment}-${var.location}"
  rg_name          = "rg-hub-net-${var.prefix}-${var.environment}-${var.location}"
  bastion_name     = "bastion-${var.prefix}-${var.environment}-${var.location}"
  bastion_pip_name = "pip-bastion-${var.prefix}-${var.environment}-${var.location}"

  nsg_name         = "nsg-default-${var.prefix}-${var.environment}-${var.location}"
  nsg_rule_rdp_name = "nsg-rule-rdp-${var.prefix}-${var.environment}-${var.location}"
}
