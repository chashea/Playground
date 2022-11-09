variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "The resource group location"
}
variable "resource_tags" {
  type        = map(string)
  description = "The resource tags"
}
