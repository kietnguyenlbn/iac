
## Imported RG of spoke vnet into Terraform
data "azurerm_resource_group" "lbn_az_rg" {
  name = var.rg_spoke_name


  
}

# Import RG of hub vnet into Terraform
data "azurerm_resource_group" "lbn_az_vnet_hub_rg" {
    name = var.rg_hub_name

    
}

# Import hub vnet into Terraform
data "azurerm_virtual_network" "lbn_az_vnet_hub" {
    name = var.vnet_hub_name
    resource_group_name = var.rg_hub_name

    

}