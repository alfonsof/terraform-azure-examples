# Input variable: Name of Storage Account
variable "storage_account_name" {
  description = "The name of the storage account. Must be globally unique, length between 3 and 24 characters and contain numbers and lowercase letters only."
  default     = "mytfstorageaccount"
}

# Input variable: Name of Storage container
variable "container_name" {
  description = "The name of the Blob Storage container."
  default     = "my-terraform-state-container"
}
