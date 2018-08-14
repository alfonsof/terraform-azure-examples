# Use Azure Resource Manager (AzureRM) provider
provider "azurerm" {
}
 
# Create Resource Group if it doesn’t exist
resource "azurerm_resource_group" "tfexample" {
  name     = "myTerraformResourceGroup"
  location = "West Europe"
}

# Create Virtual Network
resource "azurerm_virtual_network" "tfexample" {
  name                = "myTerraformVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.tfexample.location}"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"
  
  tags {
    environment = "TerraformExamples"
  }
}

# Create Subnet in the Virtual Network
resource "azurerm_subnet" "tfexample" {
  name                 = "myTerraformSubnet"
  resource_group_name  = "${azurerm_resource_group.tfexample.name}"
  virtual_network_name = "${azurerm_virtual_network.tfexample.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create public IP
resource "azurerm_public_ip" "tfexample" {
  name                         = "myTerraformPublicIP"
  location                     = "${azurerm_resource_group.tfexample.location}"
  resource_group_name          = "${azurerm_resource_group.tfexample.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "TerraformExamples"
  }
}

# Create Load Balancer
resource "azurerm_lb" "tfexample" {
  name                = "MyTerraformLoadBalancer"
  location            = "${azurerm_resource_group.tfexample.location}"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.tfexample.id}"
  }

  tags {
    environment = "TerraformExamples"
  }
}

# Create Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "tfexample" {
  name                = "BackEndAddressPool"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"
  loadbalancer_id     = "${azurerm_lb.tfexample.id}"
}

# Creste Load Balancer health probes
resource "azurerm_lb_probe" "tfexample" {
  name                = "httpProbe"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"
  loadbalancer_id     = "${azurerm_lb.tfexample.id}"
  port                = "${var.server_port}"
}

# Create a Load Balancer Rule
resource "azurerm_lb_rule" "tfexample" {
  resource_group_name            = "${azurerm_resource_group.tfexample.name}"
  loadbalancer_id                = "${azurerm_lb.tfexample.id}"
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = "${var.server_port}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tfexample.id}"
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = "${azurerm_lb_probe.tfexample.id}"
}

# Create Virtual Machine Scale Set
resource "azurerm_virtual_machine_scale_set" "tfexample" {
  name                  = "myTerraformScaleSet"
  location              = "${azurerm_resource_group.tfexample.location}"
  resource_group_name   = "${azurerm_resource_group.tfexample.name}"
  upgrade_policy_mode   = "Manual"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun            = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }

  os_profile {
    computer_name_prefix  = "myvm"
    admin_username        = "azureuser"
    admin_password        = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "MyTerraformNetworkProfile"
    primary = true

    ip_configuration {
      name                                   = "TerraformIPConfiguration"
      subnet_id                              = "${azurerm_subnet.tfexample.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.tfexample.id}"]
    }
  }

  extension {
    name                 = "hostname"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    settings             = <<SETTINGS
      {
        "commandToExecute": "echo 'Hello, World' > index.html ; nohup busybox httpd -f -p ${var.server_port} &"
      }
SETTINGS
  }

  tags {
    environment = "TerraformExamples"
  }
}