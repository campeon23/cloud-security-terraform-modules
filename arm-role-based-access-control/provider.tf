# provider "google" {
#   project     = var.GCP_PROJECT_ID
#   region      = var.GCP_REGION
#   credentials = var.GCP_CREDENTIALS
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

provider "azurerm" {
  features {}
}

provider "azuread" {
  # Optionally, specify other configurations for AzureAD provider
}
