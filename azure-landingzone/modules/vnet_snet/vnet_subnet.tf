resource "azurerm_subnet" "lbn_az_snet" {
    resource_group_name = var.rg_name
    virtual_network_name = var.vnet_name
    name = var.snet_name
    address_prefixes = [var.snet_addr]
}