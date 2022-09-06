variable "firewall_rule_collection_name" {
  description = "Firewall rule network collection name"
  type = string
}

variable "resource_group_name" {
  description = "Resource Group where the NSG is located"
  type = string
}

variable "azure_firewall_name" {
  description = "Azure Firewall Name"
  type = string
}

variable "priority" {
  description = "Priority of the rule"
  type = number
}

variable "action" {
  description = "Access Allow or Deny"
  type = string
}

variable "network_rules" {
  description = "Azure Firewall Network Rules"
  #type = list#(any)
  type = map(object({
    rule_name = string
    description = string
    source_addresses = list(string)
    destination_addresses = list(string)
    destination_ports = list(string)
    protocols = list(string)
  }))  
}