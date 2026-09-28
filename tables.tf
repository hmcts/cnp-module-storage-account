resource "azurerm_storage_table" "tables" {
  for_each           = { for table in var.tables : table => table }
  name               = each.value
  storage_account_id = azurerm_storage_account.storage_account.id
}
