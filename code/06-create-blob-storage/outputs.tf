# Output variable: Blob Storage container name
output "blob_storage_container" {
  value = "https://${azurerm_storage_account.terraform_state.name}.blob.core.windows.net/${azurerm_storage_container.terraform_state.name}/"
}
