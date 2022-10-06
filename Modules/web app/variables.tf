# Resource Group

variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "The resource group location"
}

# Resource

variable "resource_suffix" {
  type        = string
  description = "The resource suffix for the naming convention ie: resource-workload-environment-location-instance"
}

variable "resource_instance" {
  type        = string
  description = "The resource instance"
}

variable "resource_tags" {
  type        = map(string)
  description = "The resource tags"
}


# App Service Environment

variable "ase_subnet_id" {
  type = string
  description = "this is the subnet id of the app service"
}

# App Service Plan

variable "asp_os_type" {
    type = string
    description = "this is the os type of the app service environment"
}

variable "asp_sku_name" {
    type = string
    description = "this is the sku of the app service environment"
}

