// Create an Output for Firewall Policy ID
output "fw_policy_id" {
  value = azurerm_firewall_policy.fw_policy.id
}