resource "azurerm_app_service_environment_v3" "ase" {
    name                                    = "ase-${var.resource_suffix}-${var.resource_instance}"
    resource_group_name                     = var.resource_group_name
    location                                = var.resource_group_location
    subnet_id                               = var.ase_subnet_id
    pricing_tier                            = "I1"
    tags                                    = var.resource_tags
  
}

resource "azurerm_service_plan" "asp" {
    name                                    = "asp-${var.resource_suffix}${var.resource_instance}"
    resource_group_name                     = var.resource_group_name
    location                                = var.resource_group_location
    app_service_environment_id              = azurerm_app_service_environment_v3.ase.id
    os_type                                 = var.asp_os_type
    sku_name                                = var.asp_sku_name
    tags                                    = var.resource_tags
}


resource "azurerm_windows_web_app" "web_app" {
    name                                    = "app-${var.resource_suffix}-${var.resource_instance}"
    resource_group_name                     = var.resource_group_name
    location                                = var.resource_group_location
    app_service_plan_id                     = azurerm_service_plan.asp.id
    https_only                              = true
    site_config {
        dotnet_framework_version            = "v4.0"
        scm_type                            = "None"
        use_32_bit_worker_process           = false
        websockets_enabled                  = false
    }
    tags                                    = var.resource_tags
    vnet_route_all_enabled                  = true
}


