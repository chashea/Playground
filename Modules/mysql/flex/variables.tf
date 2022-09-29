variable "rg_name" {
  description = "The name of the resource group in which to create the MySQL Server."
  type        = string
}

variable "rg_location" {
  description = "The Azure Region in which to create the MySQL Server."
  type        = string
}

variable "rg_tags" {
  description = "The tags to associate with the MySQL Server."
  type        = map(string)  
}
