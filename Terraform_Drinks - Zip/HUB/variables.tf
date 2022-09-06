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

variable "network_security_group" {
  description = "The name of the NSG"
  type = map(object({
    nsg_name = string
    location = string
    resource_group_name = string
    tags = map(string)

    nsg_rules = map(object({
      rule_name = string
      priority = number
      direction = string
      access = string
      protocol = string
      source_port_range = string
      destination_port_range = string
      source_address_prefix = string
      destination_address_prefix = string
    }))
  }))
}

variable "public_ip" {
  description = "Public IP"
  type = map(object({
    public_ip_name = string
    location = string
    tags = map(string)
    resource_group_name = string
    allocation_method = string
    sku = string
  }))
}

variable "firewall" {
  description = "Firewall "
  type = object({
    firewall_name = string
    location = string
    tags = map(string)
    virtual_network_name = string
    public_ip_name = string
    resource_group_name = string
    firewall_network_rule = map(object({
      firewall_rule_collection_name = string
      priority = number
      action = string
      network_rules = map(object({
        rule_name = string
        description = string
        source_addresses = list(string)
        destination_addresses = list(string)
        destination_ports = list(string)
        protocols = list(string)
      }))
    }))
  })
}