
# I
locals {
  vnet_spoke_list_subnets_csv_file = csvdecode(file("./list-subnets.csv"))

}


#create the vnet with a list of address space
resource "azurerm_virtual_network" "lbn_az_vnet" {
    name = lower(var.vnet_spoke_name)
    location = data.azurerm_resource_group.lbn_az_rg.location
    resource_group_name = data.azurerm_resource_group.lbn_az_rg.name
    address_space = var.vnet_spoke_space
    dns_servers = var.vnet_spoke_dns_server

    depends_on = [data.azurerm_resource_group.lbn_az_rg]

}

module "vnet_snet" {
    source = "./modules/vnet_snet"
    vnet_name = azurerm_virtual_network.lbn_az_vnet.name
    rg_name = azurerm_virtual_network.lbn_az_vnet.resource_group_name
    count = length(local.vnet_spoke_list_subnets_csv_file)
    snet_name = local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name
    snet_addr = local.vnet_spoke_list_subnets_csv_file[count.index].subnet_prefix

    depends_on = [
      azurerm_virtual_network.lbn_az_vnet
    ]


}

data "azurerm_subnet" "data_lbn_az_snet" {
  count = length(local.vnet_spoke_list_subnets_csv_file)
  name = local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name
  virtual_network_name = azurerm_virtual_network.lbn_az_vnet.name
  resource_group_name = azurerm_virtual_network.lbn_az_vnet.resource_group_name

  depends_on = [
    module.vnet_snet
  ]

  
}

#output "out_snet_id" {
#    value = module.vnet_snet[*]
#}

module "vnet_peering" {
    source = "./modules/vnet_peering"
    peering_name_hub_spoke = lower("${var.vnet_hub_name}-peering-vnet_spoke_lbn")
    peering_name_spoke_hub = lower("vnet_spoke_lbn-peering-${var.vnet_hub_name}")
    vnet_hub_id = data.azurerm_virtual_network.lbn_az_vnet_hub.id
    vnet_hub_name = var.vnet_hub_name
    rg_hub_name = data.azurerm_resource_group.lbn_az_vnet_hub_rg.name

    vnet_spoke_name = azurerm_virtual_network.lbn_az_vnet.name
    vnet_spoke_id = azurerm_virtual_network.lbn_az_vnet.id
    rg_spoke_name = data.azurerm_resource_group.lbn_az_rg.name

    depends_on = [
      azurerm_virtual_network.lbn_az_vnet
    ]

  
}

module "route_table" {
    source = "./modules/route_table"
    rg_name = data.azurerm_resource_group.lbn_az_rg.name
    rg_location = data.azurerm_resource_group.lbn_az_rg.location
    nva_nexthop_ip = "192.168.3.100"
    vnet_hub_space = ["192.168.3.0/24","192.168.4.0/24"]
    vnet_spoke_space = azurerm_virtual_network.lbn_az_vnet.address_space
    snet_fwp_lbi = "192.168.3.0/28"
    count = length(local.vnet_spoke_list_subnets_csv_file)
    route_table_name = lower("${local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name}-udr")
    local_snet_addr = local.vnet_spoke_list_subnets_csv_file[count.index].subnet_prefix

    depends_on = [
      azurerm_virtual_network.lbn_az_vnet,
      module.vnet_snet
    ]

}

data "azurerm_route_table" "data_lbn_az_route_table" {
  count = length(local.vnet_spoke_list_subnets_csv_file)
  name = lower("${local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name}-udr")
  resource_group_name = data.azurerm_resource_group.lbn_az_rg.name

  depends_on = [
    module.route_table
  ]
  
}

module "snet_route_table_association" {
    source = "./modules/snet_route_table_association"
    count = length(data.azurerm_subnet.data_lbn_az_snet[*].id)
    list_snet_id = element(data.azurerm_subnet.data_lbn_az_snet[*].id,count.index)
    list_route_table_id = element(data.azurerm_route_table.data_lbn_az_route_table[*].id,count.index)

    depends_on = [
      module.vnet_snet,
      module.route_table,
      data.azurerm_route_table.data_lbn_az_route_table,
      data.azurerm_subnet.data_lbn_az_snet
    ]


  
}

module "nsg" {
  source = "./modules/nsg"
  rg_name = azurerm_virtual_network.lbn_az_vnet.resource_group_name
  rg_location = azurerm_virtual_network.lbn_az_vnet.location
  count = length(local.vnet_spoke_list_subnets_csv_file)
  nsg_name = lower("${local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name}-nsg")

  depends_on = [
    module.vnet_snet
  ]

}

data "azurerm_network_security_group" "data_lbn_az_nsg" {
  count = length(local.vnet_spoke_list_subnets_csv_file)
  name = lower("${local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name}-nsg")
  resource_group_name = data.azurerm_resource_group.lbn_az_rg.name

  depends_on = [
    module.nsg,
    module.vnet_snet
  ]

  
}
  

module "snet_nsg_association" {
  source = "./modules/snet_nsg_association"
  count = length(data.azurerm_subnet.data_lbn_az_snet[*].id)
  list_snet_id = element(data.azurerm_subnet.data_lbn_az_snet[*].id,count.index)
  list_nsg_id = element(data.azurerm_network_security_group.data_lbn_az_nsg[*].id,count.index)

  depends_on = [
    module.vnet_snet,
    module.nsg,
    data.azurerm_subnet.data_lbn_az_snet,
    data.azurerm_network_security_group.data_lbn_az_nsg

  ]

}