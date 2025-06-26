terraform {
  required_version = ">=1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.11.0, <4.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}