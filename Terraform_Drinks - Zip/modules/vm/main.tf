terraform {
  required_version = "~> 0.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.50.0"
    }
  }
}

# Load Azure Virtual Network Data
data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

# Load Azure Subnet Data
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
}

# Create Network Public IP
resource "azurerm_public_ip" "vmpip" {
  name                = "${var.vmname}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tags.environment
  }  
}

# Create Virtual Network Interface
resource "azurerm_network_interface" "vmnic" {
  name                = "${var.vmname}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmpip.id
  }

  tags = {
    environment = var.tags.environment
  }  
}

# Create Azure Virtual Machine Linux Ubuntu
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vmname
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B2ms"
  admin_username                  = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vmnic.id,
  ]

  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = var.tags.environment
  }  
}