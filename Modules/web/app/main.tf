

# App Service

resource "azurerm_app_service" "app" {
    name                                    = "${var.app_name}"
    resource_group_name                     = var.rg_name
    location                                = var.rg_location
    app_service_plan_id                     = var.asp_id    
    site_config {
        dotnet_framework_version            = var.site_config_dotnet_framework_version
        scm_type                            = var.site_config_scm_type
    }
    app_settings                            = var.app_app_settings
    connection_string {
        name                                = var.app_connection_string_name
        value                               = var.app_connection_string_value
        type                                = var.app_connection_string_type
    }
    tags                                    = var.rg_tags
}
  

resource "azurerm_app_service_slot" "app_slot" {
  name                                      = "${var.app_slot_name}"
  app_service_name                          = azurerm_app_service.app.name
  resource_group_name                       = var.rg_name
  location                                  = var.rg_location
  app_service_plan_id                       = var.asp_id
  site_config {
    dotnet_framework_version                = var.site_config_dotnet_framework_version
    scm_type                                = var.site_config_scm_type
  }
    app_settings                            = var.app_app_settings
    connection_string {
        name                                = var.app_connection_string_name
        value                               = var.app_connection_string_value
        type                                = var.app_connection_string_type
    }

    tags                                      = var.rg_tags
}

