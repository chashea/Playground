resource "azurerm_mysql_server" "mysql-server" {
    name                    = var.mysqlserver_server_name
    location                = module.resource-group.azurerm_resource_group.rg.location
    resource_group_name     = module.resource-group.azurerm_resource_group.rg.name
    
    administrator_login          = "mysqladmin"
    administrator_login_password = "mysqladminpassword"

    sku_name                = var.mysqlserver_sku_name
    storage_mb              = var.mysqlserver_storage_mb
    version                 = var.mysqlserver_version

    create_mode             = "replica"
    ssl_enforcement_enabled = true
    ssl_minimal_tls_version_enforced = "TLS1_2"
    public_network_access_enabled = true
    geo_redundant_backup_enabled = true

    tags = module.resource-group.azurerm_resource_group.rg.tags
    
}

## Configuration
resource "azurerm_mysql_configuration" "mysql-config" {
    name                = "max_connections"
    resource_group_name = module.resource-group.azurerm_resource_group.rg.name
    server_name         = azurerm_mysql_server.mysql-server.name
    value               = "1000"
}
  

## Database
resource "azurerm_mysql_database" "mysql-db" {
    name                = "${var.mysqldb_name}"
    resource_group_name = module.resource-group.azurerm_resource_group.rg.name
    server_name         = azurerm_mysql_server.mysql-server.name
    charset             = var.mysqldb_charset
    collation           = var.mysqldb_collation
}

