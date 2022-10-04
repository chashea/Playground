# Resource Group

## Required Variables
variable "rg_name" {
  type = string
  description = "this is the name of the resource group"
}

variable "rg_location" {
  type = string
  description = "this is the location of the resource group"
}

variable "rg_tags" {
  type = map(string)
  description = "this is the tags of the resource group"
}

# Networking

## Required Variables
variable "spoke_net_name" {
    type = string
    description = "this is the name of the spoke network"  
}

variable "ase_subnet_name" {
    type = string
    description = "this is the name of the spoke network"  
}

variable "ase_subnet_address_prefix" {
    type = string
    description = "this is the name of the spoke network"  
}


# App Service Environment

## Required Variables
variable "ase_name" {
    type = string
    description = "this is the name of the app service environment"
}

variable "ase_location" {
    type = string
    description = "this is the location of the app service environment"
}

variable "ase_tags" {
    type = map(string)
    description = "this is the tags of the app service environment"
}

variable "ase_subnet_id" {
  type = string
  description = "this is the subnet id of the app service"
}


## Optional Variables
variable "ase_pricing_tier" {
    type = string
    description = "this is the pricing tier of the app service environment"
}
variable "ase_internal_load_balancing_mode" {
    type = string
    description = "this is the internal load balancing mode of the app service environment"
}

variable "ase_cluster_setting_name"{
    type = string
    description = "this is the cluster setting name of the app service environment"
}

variable "ase_cluster_setting_value" {
    type = string
    description = "this is the cluster setting value of the app service environment"
}

variable "ase_zone_redundant" {
    type = bool
    description = "this is the zone redundant of the app service environment"
}





# App Service Plan

## Required Variables

variable "asp_name" {
    type = string
    description = "this is the name of the app service"  
}

variable "ase_id"{
    type = string
    description = "this is the id of the app service environment"
}

variable "asp_os_type" {
    type = string
    description = "this is the os type of the app service environment"
}

variable "asp_sku_name" {
    type = string
    description = "this is the sku of the app service environment"
}




# App Service

## Required Variables

variable "app_name" {
    type = string
    description = "this is the name of the app service"  
}

variable "asp_id" {
    type = string
    description = "this is the id of the app service environment"
}

## Optional Variables
variable "app_app_settings" {
    type = map(string)
}

variable "app_connection_string_name" {
    type = string
    description = "this is the connection string of the app service"
}

variable "app_connection_string_value" {
    type = string
    description = "this is the connection string of the app service"
}

variable "app_connection_string_type" {
    type = string
    description = "this is the connection string of the app service"
}

variable "site_config_dotnet_framework_version" {
    type = string
    description = "this is the dotnet framework version of the app service"
}

variable "site_config_scm_type" {
    type = string
    description = "this is the scm type of the app service"
}

