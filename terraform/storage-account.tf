resource "azurerm_storage_account" "my_storage" {
  name                     = "${var.storage_account_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.azureflow_rg.name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_share" "my_share" {
  name                 = var.file_share_name
  storage_account_name = azurerm_storage_account.my_storage.name
  quota                = var.file_share_size
}

resource "azurerm_storage_share_directory" "dbt_profiles_dir" {
  name             = ".dbt"
  storage_share_id = azurerm_storage_share.my_share.id
}

resource "null_resource" "wait_for_fileshare" {
  depends_on = [azurerm_storage_share_directory.dbt_profiles_dir]
}

resource "azurerm_storage_share_file" "dbt_profiles" {
  name             = "profiles.yml"
  source           = "${path.module}/profiles.yml"
  storage_share_id = azurerm_storage_share.my_share.id
  path             = ".dbt"

  depends_on = [
    azurerm_storage_share_directory.dbt_profiles_dir,
    null_resource.wait_for_fileshare
  ]
}
