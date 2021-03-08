resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  address_space       = "${var.vnet_address_space}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.subnet1_name}"
  address_prefix       = "${var.subnet1_address_space}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${var.subnet2_name}"
  address_prefix       = "${var.subnet2_address_space}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  service_endpoints    = ["Microsoft.Storage"]
}

module "storage_account" {
  source                    = "../../"
  env                       = "${var.env}"
  storage_account_name      = "${var.storage_account_name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_kind              = "${var.account_kind}"
  account_tier              = "${var.account_tier}"
  account_replication_type  = "${var.account_replication_type}"
  access_tier               = "${var.access_tier}"
  enable_blob_encryption    = "${var.enable_blob_encryption}"
  enable_file_encryption    = "${var.enable_file_encryption}"
  enable_https_traffic_only = "${var.enable_https_traffic_only}"
  account_encryption_source = "${var.account_encryption_source}"
  team_name                 = "${var.team_name}"
  team_contact              = "${var.team_contact}"
  destroy_me                = "${var.destroy_me}"
  sa_subnets                = ["${azurerm_subnet.subnet1.id}", "${azurerm_subnet.subnet2.id}"]
  ip_rules                  = ["${var.ip_rules}"]
  depends_on                = ["${azurerm_subnet.subnet1.id}", "${azurerm_subnet.subnet2.id}"]
}
