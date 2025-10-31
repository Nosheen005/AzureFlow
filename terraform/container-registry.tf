resource "azurerm_container_registry" "containazureflow" {
  name                = "${var.acr_name}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.azureflow_rg.name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = true  
}