variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

/*variable "location" {
  type        = string
  description = "The resource location, typically matches resource group location"
}
*/
variable "workload_name" {
  type        = string
  description = "The workload or application name"
}

variable "environment" {
  type        = string
  description = "The environment dev / test / prod"
}

variable "resource_tags" {
  type        = map(string)
  description = "The base tags for all the resources"
}

