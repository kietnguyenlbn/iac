
#locals {
#  vnet_spoke_list_subnets_csv_file = csvdecode(file("./list-subnets.csv"))

#}

resource "azurerm_route_table" "lbn_az_route_table" {
#    count = length(local.vnet_spoke_list_subnets_csv_file)
#    name = lower("${local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name}-udr")
    name = var.route_table_name
    resource_group_name = var.rg_name
    location = var.rg_location
    disable_bgp_route_propagation = true

    route {
        name = "default"
        address_prefix = "0.0.0.0/0"
        next_hop_type = "VirtualAppliance"
        next_hop_in_ip_address = var.nva_nexthop_ip
    }

    route {
        name = "to_snet_local"
#        address_prefix = local.vnet_spoke_list_subnets_csv_file[count.index].subnet_prefix
        address_prefix = var.local_snet_addr
        next_hop_type = "Vnetlocal"
    }

    route {
        name = "to_snet_fw_backend"
        address_prefix = var.snet_fwp_lbi
        next_hop_type = "Vnetlocal"
    }

    route {
        name = "to_vnet_hub_addr_space_0"
        address_prefix = var.vnet_hub_space[0]
        next_hop_type = "VirtualAppliance"
        next_hop_in_ip_address = var.nva_nexthop_ip
    }

    route {
        name = "bypass_nva"
        address_prefix = "23.102.135.246/32"
        next_hop_type = "Internet"
    }

    route {
        name = "to_vnet_addr_space_0"
        address_prefix = var.vnet_spoke_space[0]
        next_hop_type = "VirtualAppliance"
        next_hop_in_ip_address = var.nva_nexthop_ip
    }

    route {
        name = "to_vnet_hub_addr_space_1"
        address_prefix = var.vnet_hub_space[1]
        next_hop_type = "VirtualAppliance"
        next_hop_in_ip_address = var.nva_nexthop_ip
    }


  
}

#resource "azurerm_subnet_route_table_association" "lbn_az_subnet_udr_association" {
#    count = length(var.list_snet_id)
#    subnet_id = element(var.list_snet_id,count.index)
#    route_table_id = element(azurerm_route_table.lbn_az_route_table[*].id,count.index)

#    depends_on = [
#        azurerm_route_table.lbn_az_route_table
#    ]

#}