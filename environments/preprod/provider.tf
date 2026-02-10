terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.2.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "azurerm" {
  features {}
}
