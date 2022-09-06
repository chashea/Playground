variable "rule_name" {
  description = "The name of the Rule"
  type = string
}

variable "priority" {
  description = "Priority of the rule"
  type = number
}

variable "direction" {
  description = "Direction of the rule Inbound or Outbound"
  type = string
}

variable "access" {
  description = "Access Allow or Deny"
  type = string
}

variable "protocol" {
  description = "Protocol TCP or UDP"
  type = string
}

variable "source_port_range" {
  description = "Source Port Range 0-65535"
  type = string
}

variable "destination_port_range" {
  description = "Destination Port Range 0-65535"
  type = string
}

variable "source_address_prefix" {
  description = "Source address prefix"
  type = string
}

variable "destination_address_prefix" {
  description = "Destination address prefix"
  type = string
}

variable "resource_group_name" {
  description = "Resource Group where the NSG is located"
  type = string
}

variable "network_security_group_name" {
  description = "The NSG Name"
  type = string
}