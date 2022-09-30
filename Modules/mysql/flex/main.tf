# Server
resource "azurerm_mysql_flexible_server" "flex_server" {
    name                              = var.flex_server_name
    resource_group_name               = var.rg_name
    location                          = var.rg_location
    administrator_login               = var.flex_administrator_login
    administrator_password            = var.flex_administrator_password
    sku_name                          = var.flex_sku_name
    backup_retention_days             = var.flex_backup_retention_days
    version                           = var.flex_version
    create_mode                       = var.flex_create_mode
    geo_redundant_backup_enabled      = var.flex_geo_redundant_backup_enabled
    zone                              = var.flex_availability_zone
    source_server_id                  = var.flex_source_server_id
    high_availability {
        mode = var.flex_high_availability
    }
    tags                              = var.rg_tags
}

# Database
resource "azurerm_mysql_flexible_database" "flex_db" {
    name                              = var.flex_db_name
    resource_group_name               = var.rg_name
    server_name                       = azurerm_mysql_flexible_server.flex_server.name
    charset                           = var.flex_db_charset
    collation                         = var.flex_db_collation
}


