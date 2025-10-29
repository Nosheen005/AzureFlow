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
        docker_image_name = "${azurerm_container_registry.containazureflow.login_server}/${var.dashboard_image_name}:${var.dashboard_image_tag}"
      }
      
    }
    
    app_settings = {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"

      DASHBOARD_DATA_PATH = "/mnt/${azurerm_storage_share.my_share.name}/"

      AZURE_STORAGE_ACCOUNT_NAME_files = azurerm_storage_account.my_storage.name
      AZURE_STORAGE_ACCOUNT_KEY_files = azurerm_storage_account.my_storage.primary_access_key
      AZURE_STORAGE_ACCOUNT_files_SHARE_NAME = azurerm_storage_share.my_share.name
      AZURE_STORAGE_ACCOUNT_files_TYPE = "AzureFiles"
      AZURE_STORAGE_ACCOUNT_files_MOUNT_PATH = "/mnt/${azurerm_storage_share.my_share.name}"
      }
}