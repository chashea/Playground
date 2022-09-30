## Resource Group

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

## Server
variable "flex_server_name" {
  type = string
  description = "this is the name of the mysql server"
}
  variable "flex_sku_name" {
    type = string
    description = "this is the sku name of the mysql server"
  }

  variable "flex_backup_retention_days" {
    type = number
    description = "this is the backup retention days of the mysql server"
  }

variable "flex_administrator_login" {
  type = string
  description = "this is the administrator login of the mysql server"
}

variable "flex_administrator_password" {
  type = string
  description = "this is the administrator password of the mysql server"
}

variable "flex_version" {
  type = string
  description = "this is the version of the mysql server"
}
variable "flex_availability_zone" {
  type = string
  description = "this is the availability zone of the mysql server"
}

variable "flex_high_availability" {
  type = string
  description = "this is the high availability of the mysql server"
}

variable "flex_geo_redundant_backup_enabled" {
  type = bool
  description = "this is the geo redundant backup enabled of the mysql server"
}

variable "flex_create_mode" {
  type = string
  description = "this is the create mode of the mysql server"
}

variable "flex_source_server_id" {
  type = string
  description = "this is the source server id of the mysql server"
}

## Database

variable "flex_db_name" {
  type = string
  description = "this is the name of the mysql database"
}

variable "flex_db_charset" {
  type = string
  description = "this is the charset of the mysql database"
}

variable "flex_db_collation" {
  type = string
  description = "this is the collation of the mysql database"
}



