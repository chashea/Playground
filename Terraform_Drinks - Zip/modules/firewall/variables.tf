variable "location" {
  type = string
  description = "Azure region resource will be built in"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
}

variable "firewall_name" {
  type = string
  description = "Azure Firewall Name"
}

variable "tags" {
  description = "The tags for the Azure resource"
  type        = map(string)
}

variable "virtual_network_name" {
  type = string
  description = "Azure Firewall Virtual Network Name"
}

variable "public_ip_name" {
  type = string
  description = "Azure Firewall Public IP Name"
}

variable "firewall_network_rule" {
  description = "The name and address prefix for the subnet"
  type        = map(object({
      firewall_rule_collection_name = string
      priority = number
      action = string
      network_rules = map(object({
        rule_name = string
        description = string
        source_addresses = list(string)
        destination_addresses = list(string)
        destination_ports = list(string)
        protocols = list(string)
      }))
    }))
}