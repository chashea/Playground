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

## Server variables


variable "mysqlserver_server_name" {
  type = string
  description = "this is the namne of the mysql server"
}

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



## Database Variables

variable "mysqldb_name" {
  type = string
  description = "this is the name of the database"
}

variable "mysqldb_charset" {
  type = string
  description = "this is the charset of the database"
}

variable "mysqldb_collation" {
  type = string
  description = "this is the collation of the database"
}

