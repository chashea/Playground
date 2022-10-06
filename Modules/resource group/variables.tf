variable "resource_group_name" {
  type = string
  description = "name of your resource group"
}

variable "resource_group_location" {
  type = string
  description = "location of your resources"
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
  description = "The resource tags"
}
