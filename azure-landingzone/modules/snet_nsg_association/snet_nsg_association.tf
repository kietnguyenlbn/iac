resource "azurerm_subnet_network_security_group_association" "lbn_az_snet_nsg_association" {
#    count = length(var.list_snet_id)
#    subnet_id = element(var.list_snet_id,count.index)
#    network_security_group_id = element(var.list_nsg_id,count.index)
    subnet_id = var.list_snet_id
    network_security_group_id = var.list_nsg_id
}