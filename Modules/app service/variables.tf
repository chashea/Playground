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
variable "ase_subnet_id" {
  type = string
  description = "this is the subnet id of the app service"
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

## Optional Variables
variable "ase_pricing_tier" {
    type = string
    description = "this is the pricing tier of the app service environment"
}

variable "ase_front_end_scale_factor" {
    type = number
    description = "this is the front end scale factor of the app service environment"
}

variable "ase_internal_load_balancing_mode" {
    type = string
    description = "this is the internal load balancing mode of the app service environment"
}

variable "ase_allowed_user_ip_cidrs" {
    type = string
    description = "this is the allowed user ip cidrs of the app service environment"
}

variable "ase_cluster_setting_name"{
    type = string
    description = "this is the cluster setting name of the app service environment"
}

variable "ase_cluster_setting_value" {
    type = string
    description = "this is the cluster setting value of the app service environment"
}





# App Service 

## Required Variables

variable "app_service_name" {
    type = string
    description = "this is the name of the app service"  
}

variable "ase_id"{
    type = string
    description = "this is the id of the app service environment"
}

