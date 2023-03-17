variable "location" {
  description = "Resource location"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}
