# Create peering from hub to spoke
resource "azurerm_virtual_network_peering" "lbn_az_peering_hub_spoke" {
    name = lower(var.peering_name_hub_spoke)
    resource_group_name = var.rg_hub_name
    virtual_network_name = var.vnet_hub_name
    remote_virtual_network_id = var.vnet_spoke_id
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    use_remote_gateways = false




}

# Create peering from spoke to hub
resource "azurerm_virtual_network_peering" "az-peering-spoke-to-hub" {
    name = lower(var.peering_name_spoke_hub)
    resource_group_name = var.rg_spoke_name
    virtual_network_name = var.vnet_spoke_name
    remote_virtual_network_id = var.vnet_hub_id
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    use_remote_gateways = false



}