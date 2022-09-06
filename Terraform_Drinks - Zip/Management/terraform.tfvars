resource_group = {
    rg1 = {
        name = "RG2",
        location = "WestUS2",
        tags = {
            evironment = "Prod",
            landzone = "spoke"
        }
    } 
}
virtual_network = {
    vnet_prod = {
        location = "WestUS2",
        tags = {
            evironment = "spoke",
            landzone = "spoke"
        },
        virtual_network_name = "vnet_spoke",
        virtual_network_address_space = ["10.2.0.0/16"],
        resource_group_name = "RG2",
        subnets = {
            default = {
                name = "default",
                address_prefix = ["10.2.0.0/24"]
            }            
        }
    }
}
virtual_network_peering = {
    vnet_peering = {
        peering_name = "spoke-to-HUB",
        resource_group_name = "RG2",
        virtual_network_name = "vnet_spoke",
        remote_virtual_network_id = "/subscriptions/4b4ea128-f1cf-47ab-8468-4e9e2ece06e6/resourceGroups/RG1/providers/Microsoft.Network/virtualNetworks/vnet_prod",
        allow_virtual_network_access = true,
        allow_forwarded_traffic = true,
        allow_gateway_transit = false,
        use_remote_gateways = false    
    }
}