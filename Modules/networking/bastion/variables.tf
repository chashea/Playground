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

variable "hub_net" {
    type = string
    description = "this is the name of the hub network"  
}


variable "bastion_host_name" {
  type = string
    description = "this is the name of the bastion host"
}

variable "bastion_subnet_name" {
  type = string
    description = "this is the name of the bastion subnet"
}

variable "bastion_subnet_address_prefix" {
  type = string
    description = "this is the address prefix of the bastion subnet"
}

variable "bastion_subnet_address_prefixes" {
  type = list(string)
    description = "this is the address prefix of the bastion subnet"
}

variable "bastion_public_ip_name" {
  type = string
    description = "this is the name of the bastion public ip"
}

variable "bastion_public_ip_sku" {
  type = string
    description = "this is the sku of the bastion public ip"
}

variable "bastion_public_ip_allocation_method" {
  type = string
    description = "this is the allocation method of the bastion public ip"
}

variable "bastion_ip_configuration_name" {
  type = string
    description = "this is the name of the bastion ip configuration"
}


variable "bastion_file_copy_enabled" {
    type = bool
    description = "this is the file copy enabled of the bastion"  
}

variable "bastion_scale_units" {
    type = number
    description = "this is the scale units of the bastion"  
}

variable "shareable_link_enabled" {
    type = bool
    description = "this is the shareable link enabled of the bastion"  
}

variable "bastion_tunneling_enabled" {
    type = bool
    description = "this is the tunneling enabled of the bastion"  
}

