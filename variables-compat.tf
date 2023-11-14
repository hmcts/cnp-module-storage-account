// TODO hide these once https://github.com/terraform-docs/terraform-docs/pull/651 is merged
// or bite the bullet and remove them breaking some repositories
variable "destroy_me" {
  default     = null
  description = "Unused, do not add to your configuration"
}

variable "team_contact" {
  default     = null
  description = "Unused, do not add to your configuration"
}
