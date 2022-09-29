output "mysqldb-name" {
  value = azurerm_mysql_database.mysql-db.name
}

output "mysqlserver-name" {
  value = azurerm_mysql_server.mysql-server.name
}

output "mysqlserver-id" {
  value = azurerm_mysql_server.mysql-server.id
}

output "mysqlserver-location" {
  value = azurerm_mysql_server.mysql-server.location
}

output "mysqlserver-rg" {
  value = azurerm_mysql_server.mysql-server.resource_group_name
}

output "mysqlserver-tags" {
  value = azurerm_mysql_server.mysql-server.tags
}

output "mysqlserver-version" {
  value = azurerm_mysql_server.mysql-server.version
}

output "mysqlserver-sku-name" {
  value = azurerm_mysql_server.mysql-server.sku_name
}

output "mysqlserver-storage-mb" {
  value = azurerm_mysql_server.mysql-server.storage_mb
}

output "mysqlserver-create-mode" {
  value = azurerm_mysql_server.mysql-server.create_mode
}

output "mysqlserver-ssl-enforcement-enabled" {
  value = azurerm_mysql_server.mysql-server.ssl_enforcement_enabled
}


output "mysqlserver-ssl-minimal-tls-version-enforced" {
  value = azurerm_mysql_server.mysql-server.ssl_minimal_tls_version_enforced
}

output "mysqlserver-public-network-access-enabled" {
  value = azurerm_mysql_server.mysql-server.public_network_access_enabled
}

output "mysqlserver-geo-redundant-backup-enabled" {
  value = azurerm_mysql_server.mysql-server.geo_redundant_backup_enabled
}

output "mysqlserver-administrator-login" {
  value = azurerm_mysql_server.mysql-server.administrator_login
}

output "mysqlserver-administrator-login-password" {
  value = azurerm_mysql_server.mysql-server.administrator_login_password
}
