## Server variables
variable "mysqlserver_server_name" {
  type = string
  description = "this is the namne of the mysql server"
}

variable "mssql_server_version" {
  type = string
  description = "engine major version"
}


## Database Variables

variable "mysqldb_name" {
  type = string
  description = "this is the name of the database"
}

