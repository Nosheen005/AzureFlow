resource "azurerm_service_plan" "my_service_plan" {
  name                = "planazureflow${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.azureflow_rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "my_web_app" {
    name               = "webappazureflow${random_string.suffix.result}"
    resource_group_name = azurerm_resource_group.azureflow_rg.name
    location           = var.location
    service_plan_id    = azurerm_service_plan.my_service_plan.id

    site_config {
        application_stack {
          docker_image = "containazureflow.azurecr.io/azureflow-webapp"
          docker_image_tag = "latest"
        }
        app_command_line = ""
        application_stack_port = 8501
    }
    app_settings = { 
    WEBSITES_PORT = "8501"
   }
}