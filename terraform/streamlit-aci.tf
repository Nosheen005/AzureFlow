resource "azurerm_container_group" "streamlit" {
  name                = var.dashboard_container_name
  location            = azurerm_resource_group.azureflow_rg.location
  resource_group_name = azurerm_resource_group.azureflow_rg.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "${var.dashboard_dns_label}${random_string.suffix.result}"  # becomes <label>.<region>.azurecontainer.io
  restart_policy      = "Always"
  depends_on          = [null_resource.push_compose_images]


  container {
    name   = "dashboard"
    image  = "${azurerm_container_registry.containazureflow.login_server}/${var.dashboard_image_name}:${var.dashboard_image_tag}"
    cpu    = 1
    memory = 2

    ports {
      port     = var.dashboard_port
      protocol = "TCP"
    }

    environment_variables = {
      DUCKDB_PATH           = "/mnt/${var.file_share_name}/${var.duckdb_file_name}"
    }

    volume {
      name       = "dashboard-files"
      mount_path = "/mnt/${var.file_share_name}"
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
