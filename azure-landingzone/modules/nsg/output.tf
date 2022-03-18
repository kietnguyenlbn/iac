output "out_nsg_id" {
    value = azurerm_network_security_group.lbn_az_nsg[*].id
}