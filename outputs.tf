output "storageaccount_id" {
  value       = "${azurerm_storage_account.storage_account.id}"
  description = "The storage account Resource ID. "
}

output "storageaccount_primary_location" {
  value       = "${azurerm_storage_account.storage_account.primary_location}"
  description = "The primary location of the storage account."
}

output "storageaccount_secondary_location" {
  value       = "${azurerm_storage_account.storage_account.secondary_location}"
  description = "The secondary location of the storage account."
}

output "storageaccount_primary_blob_endpoint" {
  value       = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
  description = "The endpoint URL for blob storage in the primary location."
}

output "storageaccount_secondary_blob_endpoint" {
  value       = "${azurerm_storage_account.storage_account.secondary_blob_endpoint}"
  description = "The endpoint URL for blob storage in the secondary location."
}

output "storageaccount_primary_queue_endpoint" {
  value       = "${azurerm_storage_account.storage_account.primary_queue_endpoint}"
  description = "The endpoint URL for queue storage in the primary location. "
}

output "storageaccount_secondary_queue_endpoint" {
  value       = "${azurerm_storage_account.storage_account.secondary_queue_endpoint}"
  description = "The endpoint URL for queue storage in the secondary location."
}

output "storageaccount_primary_table_endpoint" {
  value       = "${azurerm_storage_account.storage_account.primary_table_endpoint}"
  description = "The endpoint URL for table storage in the primary location. "
}

output "storageaccount_secondary_table_endpoint" {
  value       = "${azurerm_storage_account.storage_account.secondary_table_endpoint}"
  description = "The endpoint URL for table storage in the secpondary location."
}

output "storageaccount_primary_file_endpoint" {
  value       = "${azurerm_storage_account.storage_account.primary_file_endpoint}"
  description = "The endpoint URL for file storage in the primary location."
}

output "storageaccount_secondary_file_endpoint" {
  value       = "${azurerm_storage_account.storage_account.secondary_file_endpoint}"
  description = "The endpoint URL for file storage in the secondary location."
}

output "storageaccount_primary_access_key" {
  value       = "${azurerm_storage_account.storage_account.primary_access_key}"
  description = "The primary access key for the storage account."
  sensitive   = true
}

output "storageaccount_secondary_access_key" {
  value       = "${azurerm_storage_account.storage_account.secondary_access_key}"
  description = "The secondary access key for the storage account."
  sensitive   = true
}

output "storageaccount_primary_connection_string" {
  value       = "${azurerm_storage_account.storage_account.primary_connection_string}"
  description = "The connection string associated with the primary location."
  sensitive   = true
}

output "storageaccount_secondary_connection_string" {
  value       = "${azurerm_storage_account.storage_account.secondary_connection_string}"
  description = "The connection string associated with the secondary location."
  sensitive   = true
}

output "storageaccount_primary_blob_connection_string" {
  value       = "${azurerm_storage_account.storage_account.primary_blob_connection_string}"
  description = "The connection string associated with the primary blob location."
  sensitive   = true
}

output "storageaccount_secondary_blob_connection_string" {
  value       = "${azurerm_storage_account.storage_account.secondary_blob_connection_string}"
  description = "The connection string associated with the secondary blob location."
  sensitive   = true
}
