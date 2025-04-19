variable "kv_name" {
  type = string
}
variable "kv_rg_location" {
  type = string
}
variable "kv_rg_name" {
  type = string
}

#variable "kv_uami_name" {
 # type = string
#} -- not allowed in sandbox subscription

variable "kv_softdel_ret_day" {
  type = number
}

variable "kv_sku" {
  type = string
}

# variable "kv_purge_protection_enabled" {
#   type = bool
# } -- not allowed in sandbox subscription

variable "kv_enabled_for_disk_encryption" {
  type = bool
}

variable "kv_key_permissions" {
  type = list
}

variable "kv_certificate_permissions" {
  type = list
}

variable "kv_secret_permissions" {
  type = list
}
