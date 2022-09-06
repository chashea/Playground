variable "public_ip_name" {
  type = string
  description = "Azure Public IP Name"
}

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

variable "allocation_method" {
  type = string
  description = "Public IP allocation method Dynamic or Static"
}

variable "sku" {
  type = string
  description = "SKU Standard or Basic"
}
