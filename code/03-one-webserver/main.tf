# Set the Azure Provider source and version being used
terraform {
  required_version = ">= 0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1.0"
    }
  }
}

# Configure the Microsoft Azure provider
provider "azurerm" {
  features {}
}

# Create a Resource Group if it doesn’t exist
resource "azurerm_resource_group" "tfexample" {
  name     = "my-terraform-rg"
  location = "West Europe"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "tfexample" {
  name                = "my-terraform-vnet"
  location            = azurerm_resource_group.tfexample.location
  resource_group_name = azurerm_resource_group.tfexample.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "tfexample" {
  name                 = "my-terraform-subnet"
  resource_group_name  = azurerm_resource_group.tfexample.name
  virtual_network_name = azurerm_virtual_network.tfexample.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Public IP
resource "azurerm_public_ip" "tfexample" {
  name                = "my-terraform-public-ip"
  location            = azurerm_resource_group.tfexample.location
  resource_group_name = azurerm_resource_group.tfexample.name
  allocation_method   = "Static"

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "tfexample" {
  name                = "my-terraform-nsg"
  location            = azurerm_resource_group.tfexample.location
  resource_group_name = azurerm_resource_group.tfexample.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Network Interface
resource "azurerm_network_interface" "tfexample" {
  name                = "my-terraform-nic"
  location            = azurerm_resource_group.tfexample.location
  resource_group_name = azurerm_resource_group.tfexample.name

  ip_configuration {
    name                          = "my-terraform-nic-ip-config"
    subnet_id                     = azurerm_subnet.tfexample.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfexample.id
  }

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "tfexample" {
  network_interface_id      = azurerm_network_interface.tfexample.id
  network_security_group_id = azurerm_network_security_group.tfexample.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "tfexample" {
  name                            = "my-terraform-vm"
  location                        = azurerm_resource_group.tfexample.location
  resource_group_name             = azurerm_resource_group.tfexample.name
  network_interface_ids           = [azurerm_network_interface.tfexample.id]
  size                            = "Standard_DS1_v2"
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "my-terraform-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "my-terraform-env"
  }
}

# Configurate to run automated tasks in the VM start-up
resource "azurerm_virtual_machine_extension" "tfexample" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_linux_virtual_machine.tfexample.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "commandToExecute": "echo 'Hello, World' > index.html ; nohup busybox httpd -f -p 8080 &"
    }
  SETTINGS

  tags = {
    environment = "my-terraform-env"
  }
}

# Data source to access the properties of an existing Azure Public IP Address
data "azurerm_public_ip" "tfexample" {
  name                = azurerm_public_ip.tfexample.name
  resource_group_name = azurerm_linux_virtual_machine.tfexample.resource_group_name
}

# Output variable: Public IP address
output "public_ip" {
  value = data.azurerm_public_ip.tfexample.ip_address
}
