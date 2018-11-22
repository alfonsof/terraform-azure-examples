# Define Terraform backend using a blob storage container on Microsoft Azure for storing the Terraform state
terraform {
  backend "azurerm" {
    resource_group_name  = "myTerraformResourceGroup"
    storage_account_name = "tfstorageaccountmyaccount"
    container_name       = "terraform-state-my-container"
    key                  = "terraform.tfstate"
  }
}