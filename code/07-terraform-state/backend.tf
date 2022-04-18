# Define Terraform backend using a blob storage container on Microsoft Azure for storing the Terraform state
terraform {
  backend "azurerm" {
    resource_group_name  = "my-terraform-rg"
    storage_account_name = "mytfstorageaccount"
    container_name       = "my-terraform-state-container"
    key                  = "terraform.tfstate"
  }
}