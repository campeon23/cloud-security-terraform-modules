resource "azurerm_virtual_network" "vnet" {
  name                = "production-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.production.location
  resource_group_name = azurerm_resource_group.production.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "production-subnet"
  resource_group_name  = azurerm_resource_group.production.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "production-nic"
  location            = azurerm_resource_group.production.location
  resource_group_name = azurerm_resource_group.production.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

