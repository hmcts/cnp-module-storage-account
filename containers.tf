
resource "azurerm_storage_container" "container" {
  for_each = [for container in var.containers : {
    name        = container.name
    access_type = container.access_type
    resource    = "container"
  }]
  storage_account_name  = azurerm_storage_account.storage_account.name
  name                  = each.value.name
  container_access_type = each.value.access_type
}
