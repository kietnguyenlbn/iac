output "out_route_table_id" {
    value = azurerm_route_table.lbn_az_route_table[*].id
  
}