# Configure Azure Resource Manager (AzureRM) provider
provider "azurerm" {
}
 
# Create a Resource Group if it doesn’t exist
resource "azurerm_resource_group" "tfexample" {
  name     = "myTerraformResourceGroup"
  location = "West Europe"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "tfexample" {
  name                = "myTerraformVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.tfexample.location}"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"

  tags {
    environment = "TerraformExamples"
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "tfexample" {
  name                 = "myTerraformSubnet"
  resource_group_name  = "${azurerm_resource_group.tfexample.name}"
  virtual_network_name = "${azurerm_virtual_network.tfexample.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create Public IPs
resource "azurerm_public_ip" "tfexample" {
  name                         = "myTerraformPublicIP"
  location                     = "${azurerm_resource_group.tfexample.location}"
  resource_group_name          = "${azurerm_resource_group.tfexample.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "TerraformExamples"
  }
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "tfexample" {
  name                = "myTerraformNetworkSecurityGroup"
  location            = "${azurerm_resource_group.tfexample.location}"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"

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
}

# Create a Network Interface
resource "azurerm_network_interface" "tfexample" {
  name                = "myTerraformNic"
  location            = "${azurerm_resource_group.tfexample.location}"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"
  network_security_group_id = "${azurerm_network_security_group.tfexample.id}"

  ip_configuration {
    name                          = "myTerraformNicConfiguration"
    subnet_id                     = "${azurerm_subnet.tfexample.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.tfexample.id}"
  }
}

# Create a Virtual Machine
resource "azurerm_virtual_machine" "tfexample" {
  name                  = "myTerraformVM"
  location              = "${azurerm_resource_group.tfexample.location}"
  resource_group_name   = "${azurerm_resource_group.tfexample.name}"
  network_interface_ids = ["${azurerm_network_interface.tfexample.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "TerraformExamples"
  }
}

# Configurate to run automated tasks in the VM start-up
resource "azurerm_virtual_machine_extension" "tfexample" {
  name                 = "hostname"
  location             = "${azurerm_resource_group.tfexample.location}"
  resource_group_name  = "${azurerm_resource_group.tfexample.name}"
  virtual_machine_name = "${azurerm_virtual_machine.tfexample.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "commandToExecute": "echo 'Hello, World' > index.html ; nohup busybox httpd -f -p 8080 &"
    }
SETTINGS

  tags {
    environment = "TerraformExamples"
  }
}

# Data source to access the properties of an existing Azure Public IP Address
data "azurerm_public_ip" "tfexample" {
  name                = "${azurerm_public_ip.tfexample.name}"
  resource_group_name = "${azurerm_virtual_machine.tfexample.resource_group_name}"
}

# Output variable: Public IP address
output "public_ip" {
  value = "${data.azurerm_public_ip.tfexample.ip_address}"
}