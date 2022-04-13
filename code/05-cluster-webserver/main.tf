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

# Create a Load Balancer
resource "azurerm_lb" "tfexample" {
  name                = "my-terraform-lb"
  location            = azurerm_resource_group.tfexample.location
  resource_group_name = azurerm_resource_group.tfexample.name

  frontend_ip_configuration {
    name                 = "my-terraform-lb-frontend-ip"
    public_ip_address_id = azurerm_public_ip.tfexample.id
  }

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "tfexample" {
  name            = "my-terraform-lb-backend-pool"
  loadbalancer_id = azurerm_lb.tfexample.id
}

# Creste a Load Balancer health probes
resource "azurerm_lb_probe" "tfexample" {
  name            = "my-terraform-lb-probe"
  loadbalancer_id = azurerm_lb.tfexample.id
  port            = var.server_port
}

# Create a Load Balancer Rule
resource "azurerm_lb_rule" "tfexample" {
  name                           = "my-terraform-lb-rule"
  loadbalancer_id                = azurerm_lb.tfexample.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = var.server_port
  frontend_ip_configuration_name = "my-terraform-lb-frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.tfexample.id]
  probe_id                       = azurerm_lb_probe.tfexample.id
}

# Create a Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "tfexample" {
  name                            = "my-terraform-vm-scale-set"
  location                        = azurerm_resource_group.tfexample.location
  resource_group_name             = azurerm_resource_group.tfexample.name
  sku                             = "Standard_DS1_v2"
  instances                       = 2
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
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "my-terraform-vm-ss-nic"
    primary = true

    ip_configuration {
      name                                   = "my-terraform-vm-ss-nic-ip"
      primary                                = true
      subnet_id                              = azurerm_subnet.tfexample.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.tfexample.id]
    }
  }

  extension {
    name                 = "hostname"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.1"

    settings = <<SETTINGS
      {
        "commandToExecute": "echo 'Hello, World' > index.html ; nohup busybox httpd -f -p ${var.server_port} &"
      }
    SETTINGS
  }

  tags = {
    environment = "my-terraform-env"
  }
}
