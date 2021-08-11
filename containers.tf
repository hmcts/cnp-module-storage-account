
resource "azurerm_storage_container" "container" {
  count = length(var.containers)

  storage_account_name  = azurerm_storage_account.storage_account.name
  name                  = var.containers[count.index].name
  container_access_type = var.containers[count.index].access_type
}
