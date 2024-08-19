# General
variable "workload" {
  type = string
}

variable "location" {
  type = string
}

variable "allowed_source_address_prefixes" {
  type = list(string)
}

### Fabric ###
variable "create_fabric_capacity" {
  type = bool
}

variable "fabric_capacity_location" {
  type = string
}

variable "fabric_capacity_sku_name" {
  type = string
}

### Virtual Machine ###
variable "vm_size" {
  type = string
}

variable "vm_username" {
  type = string
}

variable "vm_public_key_path" {
  type = string
}

variable "vm_image_publisher" {
  type = string
}

variable "vm_image_offer" {
  type = string
}

variable "vm_image_sku" {
  type = string
}

variable "vm_image_version" {
  type = string
}
