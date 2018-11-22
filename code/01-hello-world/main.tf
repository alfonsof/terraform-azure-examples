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
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "tfexample" {
  name                 = "myTerraformSubnet"
  resource_group_name  = "${azurerm_resource_group.tfexample.name}"
  virtual_network_name = "${azurerm_virtual_network.tfexample.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create a Network Interface
resource "azurerm_network_interface" "tfexample" {
  name                = "myTerraformNic"
  location            = "${azurerm_resource_group.tfexample.location}"
  resource_group_name = "${azurerm_resource_group.tfexample.name}"

  ip_configuration {
    name                          = "myTerraformNicConfiguration"
    subnet_id                     = "${azurerm_subnet.tfexample.id}"
    private_ip_address_allocation = "dynamic"
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
}