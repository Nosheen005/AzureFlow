resource "azurerm_resource_group" "azureflow_rg" {
  name     = var.resource_group_name
  location = var.location
}