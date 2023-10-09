output "resource_group_name" {
    value = azurerm_resource_group.avm.name
}

output "log_analytics_workspace_id" {
    value = azurerm_log_analytics_workspace.avm.id
}
