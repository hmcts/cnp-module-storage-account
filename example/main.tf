resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_resource_group" "this" {
  name     = "local-test-rg"
  location = var.location
}

locals {
  private_endpoint_rg_name   = var.businessArea == "sds" ? "ss-${var.env}-network-rg" : "${var.businessArea}-${var.env}-network-rg"
  private_endpoint_vnet_name = var.businessArea == "sds" ? "ss-${var.env}-vnet" : "${var.businessArea}-${var.env}-vnet"
}

data "azurerm_subnet" "private_endpoints" {
  resource_group_name  = local.private_endpoint_rg_name
  virtual_network_name = local.private_endpoint_vnet_name
  name                 = "private-endpoints"
}

data "azurerm_client_config" "this" {}

module "this" {
  source                     = "../"
  env                        = var.env
  storage_account_name       = random_string.random.result
  resource_group_name        = azurerm_resource_group.this.name
  location                   = var.location
  account_kind               = var.account_kind
  private_endpoint_subnet_id = data.azurerm_subnet.private_endpoints.id

  common_tags = module.common_tags.common_tags
}

# only for use when building from ADO and as a quick example to get valid tags
# if you are building from Jenkins use `var.common_tags` provided by the pipeline
module "common_tags" {
  source = "github.com/hmcts/terraform-module-common-tags?ref=master"

  builtFrom   = "hmcts/terraform-module-postgresql-flexible"
  environment = var.env
  product     = "sds-platform"
}
