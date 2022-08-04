# Workaround until azurerm_storage_account supports isSftpEnabled property
# see https://github.com/hashicorp/terraform-provider-azurerm/issues/14736
resource "azapi_update_resource" "example_enable_sftp" {
  count       = var.enable_sftp ? 1 : 0
  type        = "Microsoft.Storage/storageAccounts@2021-09-01"
  resource_id = azurerm_storage_account.storage_account.id

  body = jsonencode({
    properties = {
      isSftpEnabled = true
    }
  })
}