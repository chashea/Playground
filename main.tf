module "resource_group" {
  source        = "./Modules/resource-group"
  rg_name       = "RG-WUS"
  rg_location   = "WestUS"
  rg_tags       = {
    "Environment" = "Dev"
    "Owner"       = "chashea"
    "Project"     = "Terraform"
  }
}


module "hub_net" {
  source                = "./Modules/networking/hub-net"
  rg_name               = module.resource_group.rg_name
  rg_location           = module.resource_group.rg_location
  rg_tags               = module.resource_group.rg_tags
  hub_net_name          = "HubNet"
  hub_net_address_space = "10.1.0.0/16"
  dns_servers           = ["10.1.0.4", "10.1.0.5"] 
  hub_net_subnet_name   = "HubNetSubnet"
  hub_net_subnet_address_prefix = "10.1.0.0/26"
  }



module "spoke_net" {
  source                = "./Modules/networking/spoke-net"
  rg_name               = module.resource_group.rg_name
  rg_location           = module.resource_group.rg_location
  rg_tags               = module.resource_group.rg_tags
  spoke_net_name        = "SpokeNet"
  spoke_net_address_space = "11.1.0.0/16"
  spoke_net_subnet_name = "SpokeNetSubnet"
  spoke_subnet_address_prefix = "11.1.0.0/26"
  }


module "ase" {
  source                = "./Modules/ase"
  rg_name               = module.resource_group.rg_name
  ase_location          = module.resource_group.rg_location
  ase_name              = "ASE"
  ase_sku               = "Standard"
  ase_capacity          = 1
  ase_subnet_id         = module.spoke_net.spoke_net_subnet_id
  ase_vnet_name         = module.spoke_net.spoke_net_name
  ase_vnet_rg           = module.resource_group.rg_name
  ase_tags              = module.resource_group.rg_tags
  asp_name              = "ASP"
  sku {
    tier                = "Standard"
    size                = "S1"
  }

  }

  module "app_service" {
  source                = "./Modules/app-service"
  rg_name               = module.resource_group.rg_name
  app_service_name      = "AppService"
  app_service_location  = module.resource_group.rg_location
  app_service_plan_id   = module.app_service_plan.app_service_plan_id
  site_config           = {
    dotnet_framework_version = "v4.0"  
  }

  app_settings          = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.14.1"
  }

  connection_string    {
    name               = "SQLConnectionString"
    type               = "SQLAzure"
    value              = "Server=tcp:sqlserver.database.windows.net,1433;Initial Catalog=sqlserver;Persist Security Info=False;User ID=sqladmin;Password=Password123;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

    app_slot_name          = "AppServiceSlot"
    app_slot_location      = module.resource_group.rg_location
    app_slot_plan_id       = module.app_service_plan.app_service_plan_id
 site_config            {
    dotnet_framework_version = "v4.0"  
}

 app_settings           {
    WEBSITE_NODE_DEFAULT_VERSION = "10.14.1"
}

 connection_string     {
    name               = "SQLConnectionString"
    type               = "SQLAzure"
    value              = "Server=tcp:sqlserver.database.windows.net,1433;Initial Catalog=sqlserver;Persist Security Info=False;User ID=sqladmin;Password=Password123;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  }