# Data source to access the properties of an existing Azure Public IP Address
data "azurerm_public_ip" "tfexample" {
  name                = azurerm_public_ip.tfexample.name
  resource_group_name = azurerm_linux_virtual_machine.tfexample.resource_group_name
}

# Output variable: Public IP address
output "public_ip" {
  value = data.azurerm_public_ip.tfexample.ip_address
}
