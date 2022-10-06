resource "azurerm_mysql_server" "mysql-server" {
    name                    = "${var.resource_suffix}${var.resource.instance}"
    location                = var.resource_group_location
    resource_group_name     = var.resource_group_name
    
    administrator_login          = "mysqladmin"
    administrator_login_password = "mysqladminpassword"

    sku_name                = var.mysqlserver_sku_name
    storage_mb              = var.mysqlserver_storage_mb
    version                 = var.mysqlserver_version
    ssl_enforcement_enabled = var.mysqlserver_ssl_enforcement_enabled
    
    tags = var.resource_tags

}

## Database
resource "azurerm_mysql_database" "mysql-db" {
    name                = "${var.resource_suffix}${var.resource.instance}"
    resource_group_name = var.resource_group_name
    server_name         = azurerm_mysql_server.mysql-server.name
    charset             = var.mysqldb_charset
    collation           = var.mysqldb_collation
}

