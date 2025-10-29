resource "azurerm_container_group" "dagster" {
  name                = var.dagster_container_name
  location            = azurerm_resource_group.azureflow_rg.location
  resource_group_name = azurerm_resource_group.azureflow_rg.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = var.dagster_dns_label  # becomes <label>.<region>.azurecontainer.io
  restart_policy      = "Always"

  container {
    name   = "dagster"
    image  = "${azurerm_container_registry.containazureflow.login_server}/${var.dagster_image_name}:${var.dagster_image_tag}"
    cpu    = 1
    memory = 2

    ports {
      port     = var.dagster_port
      protocol = "TCP"
    }

    environment_variables = {
#      DAGSTER_HOME          = "/mnt/${azurerm_storage_share.my_share.name}"
      DUCKDB_PATH           = "/mnt/${azurerm_storage_share.my_share.name}"
      DBT_PROFILES_DIR      = "/mnt/${azurerm_storage_share.my_share.name}"
    }

    volume {
      name       = "dagster-files"
      mount_path = "/mnt/${azurerm_storage_share.my_share.name}"
      read_only  = false
      share_name = azurerm_storage_share.my_share.name

      storage_account_name = azurerm_storage_account.my_storage.name
      storage_account_key  = azurerm_storage_account.my_storage.primary_access_key
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.containazureflow.login_server
    username = azurerm_container_registry.containazureflow.admin_username
    password = azurerm_container_registry.containazureflow.admin_password
  }
}
