variable "resource_group" {
  description = "The name of the resource group in which the resources are created"
  type = map(object({
    name = string
    location = string
    tags = map(string)
  }))
}

variable "virtual_network" {
  description = "The name of the virtual network"
  type = map(object({
    location = string
    tags = map(string)
    virtual_network_name = string
    virtual_network_address_space = list(string)
    location = string
    resource_group_name = string
    subnets = map(object({
      name = string
      address_prefix = list(string)
    }))
    tags = map(string)
  }))
}

variable "virtual_network_peering" {
  description = "Virtual Network Peering object"
  type = map(object({
    peering_name = string
    resource_group_name = string
    virtual_network_name = string
    remote_virtual_network_id = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic = bool
    allow_gateway_transit = bool
    use_remote_gateways = bool
  }))
}