# Stores the state as a given key in a given blob storage container on Microsoft Azure
terraform {
  backend "azurerm" {
    resource_group_name  = "myTerraformResourceGroup"
    storage_account_name = "tfstorageaccountafb"
    container_name       = "terraform-state-afb"
    key                  = "terraform.tfstate"
  }
}