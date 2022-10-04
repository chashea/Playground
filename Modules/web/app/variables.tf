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

