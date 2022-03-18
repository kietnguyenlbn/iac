
terraform {
  required_providers {
      azurerm = {
          source = "hashicorp/azurerm"
          version = ">= 2.80.0"
      }
  }
}

provider "azurerm" {
    features {    
    }
    subscription_id = "54d87296-b91a-47cd-93dd-955bd57b3e9a"
    client_id = "b9c5e130-bdea-4183-9d13-d5ceb1815990"
    client_secret = "Tnj6-S2TPNH04ACAXoxHgx-r5qEjIMFKFd"
    tenant_id = "7d37f2bd-a1dc-4e2c-aaa3-c758dc77fff7"

}