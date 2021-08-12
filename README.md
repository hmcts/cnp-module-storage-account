# cnp-module-storage-account
Terraservice Module for creating an Azure Resource Manager based storage account.

## Testing
The directories under `test/` provide different testing scenarios.  To use:
* Change to the directory of your choosing and run `terraform init`
* Run `terraform plan, apply`, etc...

## How to use this module

Example:

```
module "storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account.git?ref=master"
  env                      = var.env
  storage_account_name     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.azurerm_location
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
      name = "BlobRetionPolicy"
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