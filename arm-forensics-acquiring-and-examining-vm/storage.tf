resource "azurerm_storage_account" "storage" {
  name                     = "ccsestorage"
  resource_group_name      = azurerm_resource_group.forensics.name
  location                 = azurerm_resource_group.forensics.location
  account_tier             = "Standard"
  account_replication_type = "GRS"  # Geo-redundant storage
  account_kind             = "StorageV2"

  min_tls_version = "TLS1_2"
}

resource "azurerm_storage_share" "file_share" {
  name                 = "ccsefileshare"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50  # Set appropriate size for the file share
}