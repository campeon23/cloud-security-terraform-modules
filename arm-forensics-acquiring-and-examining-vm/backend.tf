terraform {
    backend "azurerm" {
        resource_group_name   = "ECCLabResourceGroup"
        storage_account_name  = "ecclabstorageacc"
        container_name        = "wildbtfstatebucket"
        key                   = "terraform/arm-role-based-access-control/terraform.tfstate"
    }
    required_version = ">= 1.7.0" # Replace with the minimum version you want to require

    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.88.0" # Replace with the version constraint for the AzureRM provider
        }
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 2.47.0" # Replace with the version constraint for the AzureAD provider
        }
    }
}
