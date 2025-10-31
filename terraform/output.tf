# Terraform Outputs for Resource Group
output "resource_group_name" {
  value       = azurerm_resource_group.azureflow_rg.name
  description = "The name of the resource group"
}
output "resource_group_location" {
  value       = azurerm_resource_group.azureflow_rg.location
  description = "The location of the resource group"
}

# Terraform Outputs for Azure Container Registry
output "acr_login_server" {
  value = azurerm_container_registry.containazureflow.login_server
  description = "The login server URL of the Azure Container Registry"
}
output "acr_admin_username" {
  value = azurerm_container_registry.containazureflow.admin_username
  description = "The admin username of the Azure Container Registry"
  sensitive = true
}
output "acr_admin_password" {
  value = azurerm_container_registry.containazureflow.admin_password
  description = "The admin password of the Azure Container Registry"
  sensitive = true
}

# Terraform Outputs for Storage Account and File Share
output "storage_account_name" {
  value = azurerm_storage_account.my_storage.name
  description = "The name of the created storage account for database/profiles.yml"
}
output "storage_account_key" {
  value = azurerm_storage_account.my_storage.primary_access_key
  description = "The primary access key of the storage account"
  sensitive = true
}
output "file_share_name" {
  value = azurerm_storage_share.my_share.name
  description = "The name of the created file share for database/profiles.yml"
}

# Terraform Outputs for Web App
#output "web_app_url" {
#  value = azurerm_linux_web_app.my_web_app.default_hostname
#  description = "The URL of the deployed web application"
#}

# Terraform Outputs for Dagster ACI
output "dagster_url" {
  description = "Public URL for Dagster's web interface"
  value       = "https://${azurerm_container_group.dagster.fqdn}:${var.dagster_port}"
}