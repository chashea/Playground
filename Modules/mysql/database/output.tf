output "mysqldb-name" {
  value = azurerm_mysql_database.mysql-db.name
}

output "mysqlserver-name" {
  value = azurerm_mysql_server.mysql-server.name
}

output "mysqlserver-id" {
  value = azurerm_mysql_server.mysql-server.id
}


