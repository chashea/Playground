resource_group = {
    rg1 = {
        name = "RG1",
        location = "WestUS2",
        tags = {
            evironment = "Prod"
        }
    } 
}
virtual_network = {
    vnet_prod = {
        location = "WestUS2",
        tags = {
            evironment = "Prod"
        },
        virtual_network_name = "vnet_prod",
        virtual_network_address_space = ["10.1.0.0/16"],
        resource_group_name = "RG1",
        subnets = {
            default = {
                name = "default",
                address_prefix = ["10.1.0.0/24"]
            },
            test = {
                name = "test",
                address_prefix = ["10.1.1.0/24"]
            },
            AzureFirewallSubnet = {
                name = "AzureFirewallSubnet",
                address_prefix = ["10.1.255.0/24"]
            },
            Subtest1 = {
                name = "Subtest1",
                address_prefix = ["10.1.2.0/24"]
            },
            Subtest2 = {
                name = "Subtest2",
                address_prefix = ["10.1.3.0/24"]
            },
            Subtest3 = {
                name = "Subtest3",
                address_prefix = ["10.1.4.0/24"]
            }
        }
    }
}
virtual_network_peering = {
    vnet_peering = {
        peering_name = "HUB-to-spoke",
        resource_group_name = "RG1",
        virtual_network_name = "vnet_prod",
        remote_virtual_network_id = "/subscriptions/d9759156-c58b-4373-b08a-e7b28d114df4/resourceGroups/RG2/providers/Microsoft.Network/virtualNetworks/vnet_spoke",
        allow_virtual_network_access = true,
        allow_forwarded_traffic = true,
        allow_gateway_transit = false,
        use_remote_gateways = false    
    }
}
network_security_group = {
    NSG1 = {
        nsg_name = "NSG1"
        location = "WestUS2",
        resource_group_name = "RG1",
        tags = {
            evironment = "Prod"
        },
        nsg_rules = {
            http = {
                rule_name                  = "http",
                priority                   = 201,
                direction                  = "Inbound",
                access                     = "Allow",
                protocol                   = "Tcp",
                source_port_range          = "*",
                destination_port_range     = "80",
                source_address_prefix      = "*",
                destination_address_prefix = "192.168.2.0/24"
            },
            rdp = {
                rule_name                  = "rdp",
                priority                   = 100,
                direction                  = "Inbound",
                access                     = "Allow",
                protocol                   = "Tcp",
                source_port_range          = "*",
                destination_port_range    = "3389",
                source_address_prefix      = "VirtualNetwork",
                destination_address_prefix = "*"
            },
            sql = {
                rule_name                  = "sql",
                priority                   = 101,
                direction                  = "Inbound",
                access                     = "Allow",
                protocol                   = "Tcp",
                source_port_range          = "*",
                destination_port_range     = "1433",
                source_address_prefix      = "SqlManagement",
                destination_address_prefix = "192.168.2.0/24"
            }            
        }
    }
}
public_ip = {
    fw_public_ip = {
        public_ip_name = "fw_public_ip",
        location = "WestUS2",
        tags = {
            evironment = "Prod"
        },
        resource_group_name = "RG1",
        allocation_method = "Static",
        sku = "Standard"
    } 
}
firewall = {
    firewall_name = "firewall",
    location = "WestUS2",
    tags = {
        evironment = "Prod"
    },
    resource_group_name = "RG1",
    virtual_network_name = "vnet_prod",
    public_ip_name = "fw_public_ip",
    firewall_network_rule = {
        First_Collection_Name = {
            firewall_rule_collection_name = "First_Collection_Name",
            priority = 100,
            action = "Allow",
            network_rules = {
                SSH = {
                    rule_name = "SSH",
                    description = "*",
                    source_addresses = ["*"],
                    destination_addresses = ["*"],
                    destination_ports = ["22"],
                    protocols = ["TCP"],
                }
            }
        }
    }
}