## Hub
variable "rg_name" {
  default = "Rg-Hub-WUS"
}

variable "rg_location" {
  default = "westus"
}

# Virtual Network
variable "hubvnet_name" {
  default = "Vnet-Hub-WUS"
}

variable "hubvnet_address_space" {
  default = "10.15.0.0/24"
}
