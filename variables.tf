variable "name" {
  description = "(Required) Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  default     = "description"
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "uksouth"
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are Storage, StorageV2 and BlobStorage. Changing this forces a new resource to be created. Defaults to Storage"
}

variable "account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created"
  default     = "Premium"
}

variable "account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

variable "access_tier" {
  description = "(Optional) Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cold, defaults to Hot."
  default     = "Hot"
}

variable "enable_blob_encryption" {
  description = "(Optional) Boolean flag which controls if Encryption Services are enabled for Blob storage, see https://azure.microsoft.com/en-us/documentation/articles/storage-service-encryption/ for more information."
}

variable "enable_file_encryption" {
  description = "(Optional) Boolean flag which controls if Encryption Services are enabled for File storage, see https://azure.microsoft.com/en-us/documentation/articles/storage-service-encryption/ for more information."
}

variable "enable_https_traffic_only" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see https://docs.microsoft.com/en-us/azure/storage/storage-require-secure-transfer/ for more information."
}

variable "account_encryption_source" {
  description = "(Optional) The Encryption Source for this Storage Account. Possible values are Microsoft.Keyvault and Microsoft.Storage. Defaults to Microsoft.Storage."
}

variable "custom_domain" {
  description = "(Optional) A custom_domain block as documented below."
}
