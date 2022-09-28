variable "rg_name" {
  type = string
  description = "name of your resource group"
}

variable "rg_location" {
  type = string
  description = "location of your resources"
}

variable "rg_tags" {
  type = map(string)
  description = "tags for your resources"
}