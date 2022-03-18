terraform {
    backend "azurerm" {
        resource_group_name = "RG_KING3_20220310"
        storage_account_name = "stking3azureprdiac"
        container_name = "infraascode-king3"
        key = "terraform_lvmh.tfstate"
        access_key = "fg66C5FrPeMKg/pxZpiDnbt7juIW4CuzUxKjXRVRTd3rWh9Nw+wKNW/Jm8ATtEldb1xel9tiCnmo2xetf4k85A=="
    }
}