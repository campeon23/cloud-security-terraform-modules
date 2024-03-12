resource "azurerm_linux_virtual_machine" "vm" {
  name                = "production-ubuntu"
  resource_group_name = azurerm_resource_group.production.name
  location            = azurerm_resource_group.production.location
  size                = "Standard_B1s"
  admin_username      = "wildbeccadmin"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "wildbeccadmin"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

