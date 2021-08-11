variable "env" {}
variable "storage_account_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "account_kind" {}
variable "account_tier" {}
variable "account_replication_type" {}
variable "access_tier" {}
variable "enable_blob_encryption" {}
variable "enable_file_encryption" {}
variable "enable_https_traffic_only" {}
variable "account_encryption_source" {}

variable "ip_rules" {
<<<<<<< HEAD
  type = list(string)
}

variable "sa_subnets" {
  type = list(string)
=======
  type = list(any)
}

variable "sa_subnets" {
  type = list(any)
>>>>>>> master
}

variable "team_name" {}
variable "team_contact" {}
variable "destroy_me" {}
variable "vnet_name" {}

variable "vnet_address_space" {
<<<<<<< HEAD
  type = list(string)
=======
  type = list(any)
>>>>>>> master
}

variable "subnet1_name" {}
variable "subnet1_address_space" {}

variable "subnet2_name" {}
variable "subnet2_address_space" {}

variable "depends_on" {
  default = []

<<<<<<< HEAD
  type = list(string)
=======
  type = list(any)
>>>>>>> master
}
