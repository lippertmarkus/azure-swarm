resource "azurerm_storage_account" "main" {
  name                     = replace("${local.name}-storage", "/[^[:alnum:]]/", "")
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}