output "fw_parent_policy_id" {
  value = azurerm_firewall_policy.fw_parent_policy.id
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "rg_hub_name" {
  value = azurerm_resource_group.rg.name
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.vnet.name

}