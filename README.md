# cnp-module-storage-account
Terraservice Module for creating an Azure Resource Manager based storage account.

## Testing
The directories under `test/` provide different testing scenarios.  To use:
* Change to the directory of your choosing and run `terraform init`
* Run `terraform plan, apply`, etc...

## How to use this module

Minimal example:

```terraform
module "this" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account.git?ref=master"
  env                      = var.env
  storage_account_name     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type
}
```

More options:

```terraform
module "this" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account.git?ref=master"
  env                      = var.env
  storage_account_name     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier

  ip_rules = var.ip_rules

  sa_subnets = var.sa_subnets
  
  managed_identity_object_id = var.managed_identity_object_id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]
}
```

## Important note about network access 

This module will automatically prevent access to Storage Account data plane from public internet.

You need to explicitly provide either list of public IP's or Azure subnets ID's to allow access.

Two variables responsible for those settings are: `ip_rules` and `sa_subnets`

Example:

```
  ip_rules = [
    "86.14.143.106",
    "213.121.161.124",
  ]
```

```
  sa_subnets = [
    "/subscriptions/<some_subscription_id>/resourcegroups/<some_rg>/providers/microsoft.network/virtualnetworks/<some_vnet>/subnets/test-subnet1",
    "/subscriptions/<some_subscription_id>/resourcegroups/<some_rg>/providers/microsoft.network/virtualnetworks/<some_vnet>/subnets/test-subnet2"
  ]
```

Alternatively enable private endpoints:

```terraform
locals {
  private_endpoint_rg_name   = var.businessArea == "sds" ? "ss-${var.env}-network-rg" : "${var.businessArea}-${var.env}-network-rg"
  private_endpoint_vnet_name = var.businessArea == "sds" ? "ss-${var.env}-vnet" : "${var.businessArea}-${var.env}-vnet"
}

# CFT only, on SDS remove this provider
provider "azurerm" {
  alias           = "private_endpoints"
  subscription_id = var.aks_subscription_id
  features {}
  skip_provider_registration = true
}

data "azurerm_subnet" "private_endpoints" {
  # CFT only you will need to provide an extra provider, uncomment the below line, on SDS remove this line and the next
  # azurerm.private_endpoints

  resource_group_name  = local.private_endpoint_rg_name
  virtual_network_name = local.private_endpoint_vnet_name
  name                 = "private-endpoints"
}

module "this" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account.git?ref=master"
  env                      = var.env
  storage_account_name     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type

  private_endpoint_subnet_id = data.azurerm_subnet.private_endpoints.id
}
```

variables.tf:

```terraform
variable "businessArea" {
  default = "" # sds or cft, fill this in
}

variable "aks_subscription_id" {} # supplied by the Jenkins library and only needed on CFT
```

## Using this module with new subnet

This module was created with assumption that all required subnets are already present in Azure prior to running it.

In special cases when as part of running this module you are also creating new subnet which should be added to subnet rules inside storage account please ensure to use `depends_on` section. 
This way module will wait for subnet to get created first before attempting to reference it.

For examples you can refer to files inside test folder of this repository.

Example: 

```
depends_on = ["${azurerm_subnet.subnet1.id}","${azurerm_subnet.subnet2.id}"]
```

## Assigning roles to a Managed Identity
In order to grant access to the Storage Account to a specific Managed Identity, you can provide the Object Id for 
MI along with a list of [roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage) 
to assign to it. There is a variable called `allowed_roles` in [main.tf](./main.tf) which is whitelist of roles which 
can be used. A PR will be needed if different roles are required.

## Management Policy
Management Policy creates a lifecycle policy for the storage account.
Currently there is only version deletion policy coded in, but it can be expanded to consider more actions.

[Terraform Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy)

### Example Usage
```
sa_policy = [
    {
      name = "BlobRetentionPolicy"
      filters = {
        prefix_match = ["container1/prefix1"]
        blob_types   = ["blockBlob"]
      }
      actions = {
        version_delete_after_days_since_creation = 180
      }
    }
  ]
```

## Enabling SFTP Connectivity

SFTP connectivity for Azure storage acount is only supported on certain SKUs. 

Ensure:
- `account_kind` is set to either `StorageV2` or `BlockBlobStorage`.
- Hierarchical namespace (HNS) is enabled on the storage account by setting `enable_hns` to `true`. 
- `enable_sftp` is set to true

```terraform
module "sftp_storage" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account.git?ref=master"
  
  ...
  
  account_kind             = "StorageV2"
  enable_hns               = true
  enable_sftp              = true
}

[Azure Documentation on Storage Account SFTP](https://learn.microsoft.com/en-us/azure/storage/blobs/secure-file-transfer-protocol-support-how-to?tabs=azure-portal)

### Creating Local Users

To actually connect via SFTP, you will require a local user for the storage account, as well as an SSH keypair. `azurerm_storage_account_local_user` has been added to facilitate management of local users via terraform.

[Terraform Documentation on Storage Account Local Users](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_local_user)

