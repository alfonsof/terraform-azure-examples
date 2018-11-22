# Configure Azure Resource Manager (AzureRM) provider
provider "azurerm" {
}
 
# Create a Resource Group if it doesn’t exist
resource "azurerm_resource_group" "tfexample" {
  name     = "myTerraformResourceGroup"
  location = "West Europe"
}

# Create a Storage account
resource "azurerm_storage_account" "terraform_state" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.tfexample.name}"
  location                 = "${azurerm_resource_group.tfexample.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    environment = "TerraformExamples"
  }
}

# Create a Storage container
resource "azurerm_storage_container" "terraform_state" {
  name                  = "${var.container_name}"
  resource_group_name   = "${azurerm_resource_group.tfexample.name}"
  storage_account_name  = "${azurerm_storage_account.terraform_state.name}"
  container_access_type = "private"
}
