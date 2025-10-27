resource "azurerm_storage_account" "my_storage" {
  name                     = "storeazureflow${random_string.suffix.result}"
  account_tier             = "Standard"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.storage_rg.name
  account_replication_type = "LRS"

  tags = { environment = "staging" }
}

resource "azurerm_storage_share" "my_share" {
  name                 = "shareazureflow"
  storage_account_name = azurerm_storage_account.my_storage.name
  quota                = 50
}