resource "azurerm_storage_account" "my_storage" {
  name                     = "${var.storage_account_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.azureflow_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = { environment = "staging" }
}

resource "azurerm_storage_share" "my_share" {
  name                 = var.file_share_name
  storage_account_name = azurerm_storage_account.my_storage.name
  quota                = var.file_share_size
}