resource "azurerm_service_plan" "my_service_plan" {
  name                = "${var.service_plan_name}${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.azureflow_rg.name
  sku_name            = var.web_app_sku
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "my_web_app" {
    name                = "${var.web_app_name}${random_string.suffix.result}"
    resource_group_name = azurerm_resource_group.azureflow_rg.name
    location            = var.location
    service_plan_id     = azurerm_service_plan.my_service_plan.id
    depends_on          = [null_resource.push_compose_images]


    site_config {
      application_stack {
        docker_image_name        = "/${var.dashboard_image_name}:${var.dashboard_image_tag}"
        docker_registry_url      = "https://${azurerm_container_registry.containazureflow.login_server}"
        docker_registry_username = azurerm_container_registry.containazureflow.admin_username
        docker_registry_password = azurerm_container_registry.containazureflow.admin_password
      }

    }
    
    app_settings = {

      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
      WEBSITES_PORT = "8501"

      DUCKDB_PATH = "/mnt/${var.file_share_name}/${var.duckdb_file_name}"

      AZURE_STORAGE_ACCOUNT_NAME_files       = azurerm_storage_account.my_storage.name
      AZURE_STORAGE_ACCOUNT_KEY_files        = azurerm_storage_account.my_storage.primary_access_key
      AZURE_STORAGE_ACCOUNT_files_SHARE_NAME = azurerm_storage_share.my_share.name
      AZURE_STORAGE_ACCOUNT_files_TYPE       = "AzureFiles"
      AZURE_STORAGE_ACCOUNT_files_MOUNT_PATH = "/mnt/${azurerm_storage_share.my_share.name}"
    }

    identity {
      type = "SystemAssigned"
    }
    
}