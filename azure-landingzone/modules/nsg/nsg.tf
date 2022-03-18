
resource "azurerm_network_security_group" "lbn_az_nsg" {
#    count = length(local.vnet_spoke_list_subnets_csv_file)
#    name = lower("${local.vnet_spoke_list_subnets_csv_file[count.index].subnet_name}-nsg")
    name = var.nsg_name
    resource_group_name = var.rg_name
    location = var.rg_location

}