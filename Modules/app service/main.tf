# App Service Environment

resource "azurerm_app_service_environment" "ase" {
    name                                    = var.ase_name
    resource_group_name                     = var.rg_name
    location                                = var.ase_location
    tags                                    = var.ase_tags
    subnet_id                               = var.ase_subnet_id
    pricing_tier                            = var.ase_pricing_tier
    front_end_scale_factor                  = var.ase_front_end_scale_factor
    internal_load_balancing_mode            = var.ase_internal_load_balancing_mode
    allowed_user_ip_cidrs                   = var.ase_allowed_user_ip_cidrs
    cluster_setting {
        name                                = var.ase_cluster_setting_name
        value                               = var.ase_cluster_setting_value
    }
}

