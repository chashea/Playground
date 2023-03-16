// Create the Variables for Virtual Network and Subnet
variable "location" {
  type        = string
  description = "The Azure Region where the resources should exist."
}
variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources."
}
variable "environment" {
  type        = string
  description = "The environment in which the resources should exist."
}
