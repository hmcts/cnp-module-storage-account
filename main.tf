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
    "Storage Blob Data Contributor"
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

  # To be refactored when the Azure Terraform Provider supports Storage Account Data Protection features - GitHub Issue: https://github.com/terraform-providers/terraform-provider-azurerm/issues/8268
  dynamic "blob_properties" {
    for_each = var.enable_data_protection == true ? [1] : []
    content {
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
  count                = length(local.role_assignments)
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = local.role_assignments[count.index]
  principal_id         = var.managed_identity_object_id
}

# To be removed when the Azure Terraform Prodider supports Storage Account Data Protection features - GitHub Issue: https://github.com/terraform-providers/terraform-provider-azurerm/issues/8268
resource "azurerm_template_deployment" "storage_account_data_protection" {
  count = var.enable_data_protection == true ? 1 : 0

  name                = format("StorageAccountDataProtection-%s", var.env)
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters = {
    "storageAccount" = azurerm_storage_account.storage_account.name
  }
  template_body = <<DEPLOY
        {
            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
                "storageAccount": {
                    "type": "string",
                    "metadata": {
                        "description": "Storage Account Name"}
                }
            },
            "variables": {},
            "resources": [
                {
                    "type": "Microsoft.Storage/storageAccounts/blobServices",
                    "apiVersion": "2019-06-01",
                    "name": "[concat(parameters('storageAccount'), '/default')]",
                    "properties": {
                        "IsVersioningEnabled": true,
                        "ChangeFeed": {
                            "enabled": true
                        },
                        "RestorePolicy": {
                            "enabled": true,
                            "days": 364
                        },
                        "ContainerDeleteRetentionPolicy": {
                            "enabled": true,
                            "days": 7
                        }
                    }
                }
            ]
        }
    DEPLOY
}