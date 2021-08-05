resource "random_string" "storage_account_random_string" {
  length  = 24
  special = false
  upper   = false
}

locals {
  default_storage_account_name = random_string.storage_account_random_string.result
  storage_account_name         = var.storage_account_name != "" ? var.storage_account_name : local.default_storage_account_name

  allowed_roles = [
    "Storage Blob Delegator",
    "Storage Blob Data Contributor",
    "Storage Blob Data Reader"
  ]

  role_assignments = [
    for role in var.role_assignments : role if contains(local.allowed_roles, role)
  ]
}

resource "azurerm_storage_account" "storage_account" {
  name                      = local.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = var.enable_https_traffic_only

  dynamic "blob_properties" {
  #blob_properties {
    for_each = var.enable_data_protection == true ? [1] : []
    content {
      versioning_enabled = true
      container_delete_retention_policy {
        days = 7
      }
      delete_retention_policy {
        days = 365
      }
    }
  }

  network_rules {
    bypass                     = ["AzureServices"]
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.sa_subnets
    default_action             = var.default_action
  }

  tags = merge(var.common_tags,
    map(
      "Deployment Environment", var.env,
      "Team Contact", var.team_contact,
      "Destroy Me", var.destroy_me
    )
  )
}

resource "azurerm_role_assignment" "storage-account-role-assignment" {
  for_each             = toset(local.role_assignments)
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = each.value
  principal_id         = var.managed_identity_object_id
}