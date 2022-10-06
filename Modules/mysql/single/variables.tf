# Resource Group

variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "The resource group location"
}

# Resource

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

## Server variables

# Required Variables


variable "mysqlserver_version" {
  type = string
  description = "engine major version"
}

variable "mysqlserver_sku_name" {
  type = string
  description = "this is the sku name of the mysql server"
}

variable "mysqlserver_storage_mb" {
  type = number
  description = "this is the storage size of the mysql server"
}

variable "mysqlserver_ssl_enforcement_enabled" {
  type = bool
  description = "this is the ssl enforcement enabled of the mysql server"
}



## Database Variables

# Required Variables
variable "mysqldb_charset" {
  type = string
  description = "this is the charset of the database"
}

variable "mysqldb_collation" {
  type = string
  description = "this is the collation of the database"
}

