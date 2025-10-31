resource "local_file" "rendered_compose" {
  filename = "${path.module}/../docker-compose.yml"
  content  = templatefile("${path.module}/../docker-compose.tpl.yml", {
    ACR_LOGIN_SERVER    = azurerm_container_registry.containazureflow.login_server
    DAGSTER_IMAGE_NAME  = var.dagster_image_name
    DAGSTER_IMAGE_TAG   = var.dagster_image_tag
    DASHBOARD_IMAGE_NAME = var.dashboard_image_name
    DASHBOARD_IMAGE_TAG  = var.dashboard_image_tag
  })
}

resource "null_resource" "push_compose_images" {
  depends_on = [
    azurerm_container_registry.containazureflow,
    local_file.rendered_compose
  ]

  triggers = {
    acr_login_server = azurerm_container_registry.containazureflow.login_server
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Logging into Azure Container Registry..."
      az acr login --name ${azurerm_container_registry.containazureflow.name}

      echo "Building Docker images from compose..."
      docker compose -f ../docker-compose.yml build

      echo "Pushing images to ACR..."
      docker compose -f ../docker-compose.yml push

      echo "Docker images successfully pushed to ${azurerm_container_registry.containazureflow.login_server}"
    EOT

    interpreter = ["bash", "-c"]
  }
}