locals {
  use_default_subnet_id      = var.private_endpoint_subnet_id == "" ? true : false
  private_endpoint_rg_name   = var.project == "sds" ? "ss-${var.env}-network-rg" : "${var.project}-${var.env}-network-rg"
  private_endpoint_vnet_name = var.project == "sds" ? "ss-${var.env}-vnet" : "${var.project}-${var.env}-vnet"
}

data "azurerm_subnet" "private_endpoints" {
  count    = var.enable_private_endpoint && local.use_default_subnet_id ? 1 : 0
  provider = azurerm.private_endpoint

  resource_group_name  = local.private_endpoint_rg_name
  virtual_network_name = local.private_endpoint_vnet_name
  name                 = "private-endpoints"
}

resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint_enabled == true ? 1 : 0

  name                = local.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = local.use_default_subnet_id ? data.azurerm_subnet.private_endpoints[0].id : var.private_endpoint_subnet_id

  private_service_connection {
    name                           = local.storage_account_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

  tags = var.common_tags
}
