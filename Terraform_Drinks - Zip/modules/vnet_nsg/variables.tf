variable "location" {
  type = string
  description = "Azure region resource will be built in"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
}

variable "tags" {
  description = "The tags for the Azure resource"
  type        = map(string)
}

variable "nsg_name" {
  description = "The name of the Network security group"
}

variable "nsg_rules" {
  description = "The name, priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix for the SSH NSG security rule"
  type        = map(object({
      rule_name = string
      priority = number
      direction = string
      access = string
      protocol = string
      source_port_range = string
      destination_port_range = string
      source_address_prefix = string
      destination_address_prefix = string
    }))
}