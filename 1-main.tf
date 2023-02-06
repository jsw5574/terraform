terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 2.0"
    }
    azuread = {
        source = "hashicorp/azuread"
        version = "~> 2.0"
        }
    random = {
        source = "hashicorp/random"
        version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "swjeong-rg"
    storage_account_name = "swjeongaccount"
    container_name = "tfstate"
    key = "terraform-custom-vnet.tfstate"
  }
}


provider "azurerm" {
    features {
      
    }
  
}

resource "random_pet" "aksrandom" {
  
}
