provider "azurerm" {
  features {}
}

provider "azuread" {
  # Optionally, specify other configurations for AzureAD provider
}


resource "azurerm_resource_group" "production" {
  name     = "Production"
  location = "East US"
}

resource "azurerm_resource_group" "forensics" {
  name     = "Forensics"
  location = "East US"
}