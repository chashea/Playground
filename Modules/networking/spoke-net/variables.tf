# Resource Group

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

# Hub Network

variable "spoke_net_name" {
  type = string
  description = "this is the name of the hub network"
}
  
variable "spoke_net_address_space" {
  type = string
  description = "this is the address space of the hub network"
}

variable "spoke_net_subnet_name" {
  type = string
  description = "this is the name of the hub network subnet"
}

variable "spoke_subnet_address_prefix" {
  type = string
  description = "this is the address prefix of the hub network subnet"
}

