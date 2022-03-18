
variable "nva_nexthop_ip" {
    type = string
}

variable "vnet_hub_space" {
    type = list(any)
  
}

variable "vnet_spoke_space" {
    type = list(any)
  
}

variable "snet_fwp_lbi" {

    type = string
  
}

variable "rg_name" {

    type = string
  
}

variable "rg_location" {

    type = string
  
}

variable "route_table_name" {
  
}

variable "local_snet_addr" {
    
}