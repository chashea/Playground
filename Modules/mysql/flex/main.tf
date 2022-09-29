# Server
resource "azurerm_mysql_flexible_server" "flex_server" {
    name                              = var.flex_server_name
    resource_group_name               = var.rg_name
    location                          = var.rg_location
    administrator_login               = var.flex_administrator_login
    administrator_password            = var.flex_administrator_password
    sku_name                          = var.flex_sku_name
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


