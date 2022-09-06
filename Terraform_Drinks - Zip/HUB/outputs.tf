output "resource_groups" {
  value = module.rg
  description = "Azure Resource Groups"
}

output "vnets" {
  value = module.vnet
  description = "Azure Resource Groups"
}

output "test" {
  value = module.vnet["vnet_prod"].subnets["test"].subnet_id
}

output "public_ip_entry" {
  value = module.public_ip["fw_public_ip"]
}

output "public_ip_all" {
  value = module.public_ip
}
