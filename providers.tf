terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "< 2.6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}
