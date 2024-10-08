variable "workload" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type = string
}

variable "admin_enabled" {
  type = bool
}

variable "allowed_source_address_prefixes" {
  type = list(string)
}

# variable "allowed_cidr" {
#   type = string
# }
