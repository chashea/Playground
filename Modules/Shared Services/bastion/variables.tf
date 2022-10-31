variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "The resource group location"
}

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
  description = "The base tags for all the resources"
}
# Bastion Required Variables

# Bastion Optional Variables
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
