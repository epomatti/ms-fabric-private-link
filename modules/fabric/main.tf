terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}

locals {
  current_user_upn = data.azuread_user.current_user.user_principal_name
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${var.workload}-fabric"
  location = var.fabric_capacity_location
}

resource "azapi_resource" "fabric_capacity" {
  type      = "Microsoft.Fabric/capacities@2022-07-01-preview"
  name      = var.workload
  location  = var.fabric_capacity_location
  parent_id = azurerm_resource_group.default.id

  # Disabling schema validation for this resource
  schema_validation_enabled = false

  body = jsonencode({
    sku = {
      name = "${var.sku_name}"
      tier = "Fabric"
    }
    properties = {
      administration = {
        members = ["${local.current_user_upn}"]
      }
    }
  })
}
