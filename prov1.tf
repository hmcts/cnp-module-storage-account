terraform {
  required_providers {
    azurerm = {
    source = "hashicorp/azurerm"
    }
    azapi = {
    source = "azure/azapi"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "azapi" {
}
