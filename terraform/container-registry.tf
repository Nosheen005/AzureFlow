resource "azurerm_container_registry" "containazureflow" {
  name                = "containazureflow"
  resource_group_name = azurerm_resource_group.azureflow_rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true  
}