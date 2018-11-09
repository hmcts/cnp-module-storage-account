//SHARED VARIABLES
variable "env" {
  type        = "string"
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "storage_account_name" {
  description = "(Required) Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
}

variable "resource_group_name" {
  type        = "string"
  description = "This is the prefix your resource group name will have for your shared infrastructure"
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
  default     = "true"
}

variable "enable_file_encryption" {
  description = "(Optional) Boolean flag which controls if Encryption Services are enabled for File storage, see https://azure.microsoft.com/en-us/documentation/articles/storage-service-encryption/ for more information."
  default     = "true"
}

variable "enable_https_traffic_only" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see https://docs.microsoft.com/en-us/azure/storage/storage-require-secure-transfer/ for more information."
  default     = "true"
}

variable "account_encryption_source" {
  description = "(Optional) The Encryption Source for this Storage Account. Possible values are Microsoft.Keyvault and Microsoft.Storage. Defaults to Microsoft.Storage."
  default     = "Microsoft.Storage"
}

variable "ip_rules" {
  type = "list"
  description = "(Optional) List of public IP addresses which will have access to storage account."
  default=[]
}

variable "sa_subnets" {
  type = "list"
  description = "(Required) List of subnet ID's which will have access to this storage account."
  default=[]
}

//TAG SPECIFIC VARIABLES
variable "team_name" {
  description = "The name of your team"
  default     = "CNP (Contino)"
}

variable "team_contact" {
  description = "The name of your Slack channel people can use to contact your team about your infrastructure"
  default     = "#Cloud-Native"
}

variable "destroy_me" {
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}

variable "common_tags" {
  type = "map"
  default = {
    "Team Name" = "pleaseTagMe"
  }
}

variable depends_on {
  default = [], 
  type = "list"
  description = "This is required only when creating subnet at the same time as storage account - please refer to readme for more info."
}