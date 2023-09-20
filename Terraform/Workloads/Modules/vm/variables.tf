// Variables for VM Module

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
  description = "Prefix for the Log Analytics Workspace"
  type        = string
}
/*variable "disk_encryption_set_id" {
  description = "The Disk Encryption Set ID which should be used for Disk Encryption"
  type        = string
}*/
variable "subnet_id" {
  description = "The Subnet ID which should be used for the VM"
  type        = string
}
/*
variable "law_id" {
  description = "The Log Analytics Workspace ID which should be used for the VM"
  type        = string
}

variable "law_key" {
  description = "The Log Analytics Workspace Key which should be used for the VM"
  type        = string
}
*/