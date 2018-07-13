resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

module "storage_account" {
  source                      = "../../"
  env                         = "${var.env}"
  storage_account_name        = "${var.storage_account_name}"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  location                    = "${var.location}"
  account_kind                = "${var.account_kind}"
  account_tier                = "${var.account_tier}"
  account_replication_type    = "${var.account_replication_type}"
  access_tier                 = "${var.access_tier}"
  enable_blob_encryption      = "${var.enable_blob_encryption}"
  enable_file_encryption      = "${var.enable_file_encryption}"
  enable_https_traffic_only   = "${var.enable_https_traffic_only}"
  account_encryption_source   = "${var.account_encryption_source}"
  team_name                   = "${var.team_name}"
  team_contact                = "${var.team_contact}"
  destroy_me                  = "${var.destroy_me}"
}