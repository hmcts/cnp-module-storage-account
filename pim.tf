resource "time_rotating" "rotate" {
  rotation_days = 360
}

resource "time_static" "pim_expiry" {
  rfc3339 = time_rotating.rotate.rotation_rfc3339
}

resource "time_static" "pim_start" {}

data "azurerm_subscription" "primary" {
}

data "azurerm_role_definition" "role_name" {
  for_each = local.pim_roles

  name  = each.key
  scope = data.azurerm_subscription.primary.id
}

locals {
  pim_roles = { for role, value in var.pim_roles : role => value if contains(local.allowed_roles, role) }
}

resource "azurerm_pim_eligible_role_assignment" "this" {
  for_each = local.pim_roles

  scope              = azurerm_storage_account.storage_account.id
  role_definition_id = data.azurerm_role_definition.role_name[each.key].id
  principal_id       = each.value.principal_id

  schedule {
    start_date_time = time_static.pim_start.rfc3339
    expiration {
      end_date_time = time_static.pim_expiry.rfc3339
    }
  }
}
