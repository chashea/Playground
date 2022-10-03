# Resource Group

variable "rg_name" {
  type = string
  description = "this is the name of the resource group"
}

# Virtual Network

variable "hub_net_name" {
    type = string
    description = "this is the name of the hub network"  
}

variable "spoke_net_name" {
    type = string
    description = "this is the name of the spoke network"  
}

variable "hub_net_id" {
    type = string
    description = "this is the id of the hub network"  
}

variable "spoke_net_id" {
    type = string
    description = "this is the id of the spoke network"  
}
  

# Peering

variable "peering_hub_net_name" {
    type = string
    description = "this is the name of the hub network"  
}

variable "peering_spoke_net_name" {
    type = string
    description = "this is the name of the spoke network"  
}




