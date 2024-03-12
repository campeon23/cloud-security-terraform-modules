# Blob Container
resource "azurerm_storage_container" "container" {
  name                  = "demoblobcontainer"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Generate a random content for the file
resource "random_string" "random_content" {
  length  = 16
  special = false
}

# Create a local file with random content
resource "local_file" "video_file" {
  content  = random_string.random_content.result
  filename = "${path.module}/video.mp4"
}

# Upload the file to the Blob Container
resource "azurerm_storage_blob" "video" {
  name                   = "video.mp4"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = local_file.video_file.filename
}
