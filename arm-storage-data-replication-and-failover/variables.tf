variable "subscription_id" {
  description = "The Subscription ID used for Azure resources"
  type        = string
  default     = "90d306b0-9a0a-4761-93bb-41c409142430" # It's safer not to have defaults for sensitive data.
}

variable "region" {
  description = "The Azure region to deploy the resources into"
  type        = string
  default     = "East US"
}

variable "location" {
  description = "The Azure location to deploy the resources into"
  type        = string
  default     = "East US 2"
}

variable "zone" {
  description = "The availability zone within the region"
  type        = string
  default     = "1"
}

variable "company" {
  description = "The name of the company"
  type        = string 
  default     = "marcourquietaproton.onmicrosoft.com"
}

# Variables - You should define these variables in your variables.tf file or pass them directly
variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "ecc-storage-replication-rg"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "ecclabstorageaccount"
}   
