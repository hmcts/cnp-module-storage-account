env = "devtest"

storage_account_name = ""

resource_group_name = "cnp-devtest"

location = "uksouth"

account_kind = "StorageV2"

account_tier = "Standard"

account_replication_type = "LRS"

access_tier = "Cool"

enable_blob_encryption = "false"

enable_file_encryption = "false"

enable_https_traffic_only = "false"

account_encryption_source = "Microsoft.Storage"

ip_rules = ["86.14.143.106", "213.121.161.124"]

sa_subnets = []

team_name = "CNP"

team_contact = "#cnp"

destroy_me = "yes"

vnet_name = "cnp-vnet"

vnet_address_space = ["10.103.12.0/22"]

subnet1_name = "cnp-subnet1"

subnet1_address_space = "10.103.13.0/24"

subnet2_name = "cnp-subnet2"

subnet2_address_space = "10.103.14.0/24"