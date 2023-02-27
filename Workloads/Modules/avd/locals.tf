// Create Local Variables
locals {
  rg_name        = "rg-${var.workload}-${var.prefix}-${var.environment}-${var.resource_location}"
  vnet_name      = "vnet-${var.workload}-${var.prefix}-${var.environment}-${var.resource_location}"
  subnet_name    = "snet-${var.workload}-${var.prefix}-${var.environment}-${var.resource_location}"
  hp_name        = "hp-${var.workload}-${var.prefix}-${var.environment}-${var.resource_location}"
  ws_name        = "ws-${var.workload}-${var.prefix}-${var.environment}-${var.resource_location}"
  ag_name        = "ag-${var.workload}-${var.prefix}-${var.environment}-${var.resource_location}"
  sh_name        = "sh-${var.prefix}"
  admin_password = "Password1234!"
  admin_username = "cshea15"
  sh_nic_name    = "sh-nic-${var.prefix}"
}