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

output "mysqlserver-fqdn" {
  value = azurerm_mysql_server.mysql-server.fqdn
}

output "mysqlserver-replication-role" {
  value = azurerm_mysql_server.mysql-server.replication_role
}


output "mysqlserver-master-server-id" {
  value = azurerm_mysql_server.mysql-server.master_server_id
}

output "mysqlserver-replica_capacity" {
  value = azurerm_mysql_server.mysql-server.replica_capacity
}

output "mysqlserver-replica_count" {
  value = azurerm_mysql_server.mysql-server.replica_count
}

output "mysqlserver-storage-profile" {
  value = azurerm_mysql_server.mysql-server.storage_profile
}

output "mysqlserver-user-visible-state" {
  value = azurerm_mysql_server.mysql-server.user_visible_state
}

output "mysqlserver-fully-qualified-domain-name" {
  value = azurerm_mysql_server.mysql-server.fully_qualified_domain_name
}

output "mysqlserver-earliest-restore-date" {
  value = azurerm_mysql_server.mysql-server.earliest_restore_date
}

output "mysqlserver-earliest-backup-date" {
  value = azurerm_mysql_server.mysql-server.earliest_backup_date
}

output "mysqlserver-earliest-restore-date-time" {
  value = azurerm_mysql_server.mysql-server.earliest_restore_date_time
}

output "mysqlserver-earliest-backup-date-time" {
  value = azurerm_mysql_server.mysql-server.earliest_backup_date_time
}

