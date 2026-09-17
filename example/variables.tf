variable "env" {
  default = "sbox"
}

variable "enable_soft_delete" {
  type    = bool
  default = null
}

variable "soft_delete_retention_days" {
  type    = number
  default = null
}

variable "location" {
  default = "UK South"
}

variable "account_kind" {
  default = "StorageV2"
}

variable "businessArea" {
  default = "sds"
}
