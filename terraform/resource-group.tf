resource "azurerm_resource_group" "storage_rg" {
  name     = "AzureFlowTerraform" + var.Username
  location = var.location
}