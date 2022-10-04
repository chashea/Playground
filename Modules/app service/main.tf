# App Service Environment Subnet

resource "azurerm_subnet" "ase_subnet" {
    name                                    = "${var.ase_subnet_name}"
    resource_group_name                     = var.rg_name
    virtual_network_name                    = var.spoke_net_name
    address_prefixes                        = [var.ase_subnet_address_prefix]
  
}

# App Service Environment
resource "azurerm_app_service_environment_v3" "asev3" {
    name                                    = "${var.ase_name}"
    resource_group_name                     = var.rg_name
    location                                = var.ase_location
    subnet_id                               = var.ase_subnet_id
    tags                                    = var.ase_tags
    cluster_setting {
        name                                = var.ase_cluster_setting_name
        value                               = var.ase_cluster_setting_value
    }

    cluster_setting {
        name                                = var.ase_cluster_setting_name
        value                               = var.ase_cluster_setting_value
    }

    cluster_setting {
        name                                = var.ase_cluster_setting_name
        value                               = var.ase_cluster_setting_value
    }

}
# App Service Plan
resource "azurerm_service_plan" "asp" {
    name                                    = "${var.asp_name}"
    resource_group_name                     = var.rg_name
    location                                = var.rg_location
    os_type                                 = var.asp_os_type
    sku_name                                = var.asp_sku_name
    app_service_environment_id              = var.ase_id
    tags                                    = var.rg_tags
}


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
  

