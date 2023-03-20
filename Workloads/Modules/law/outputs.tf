// Create Output for log Analytics Workspace ID
output "law_id" {
  value = azurerm_log_analytics_workspace.law.id
}

// Create Output for log Analytics Workspace Primary Shared Key
output "law_key" {
  value = azurerm_log_analytics_workspace.law.primary_shared_key
}

// Create Output for Log Analytics Workspace Name
output "law_name" {
  value = azurerm_log_analytics_workspace.law.name
}