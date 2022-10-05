variable "resource_group_name" {
  type = string
  description = "name of your resource group"
}

variable "resource_group_location" {
  type = string
  description = "location of your resources"
}

variable "resource_group_tags" {
  type = map(string)
  description = "tags for your resources"
}