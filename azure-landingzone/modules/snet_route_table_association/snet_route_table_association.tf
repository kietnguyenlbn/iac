resource "azurerm_subnet_route_table_association" "lbn_az_subnet_udr_association" {
#    count = length(var.list_snet_id)
#    subnet_id = element(var.list_snet_id,count.index)
#    route_table_id = element(var.list_route_table_id,count.index)
    subnet_id = var.list_snet_id
    route_table_id = var.list_route_table_id



}