terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

data "azurerm_client_config" "current" {}

locals {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azapi_resource" "powerbi" {
  type      = "Microsoft.PowerBI/privateLinkServicesForPowerBI@2020-06-01"
  name      = "fabricpls"
  location  = "global"
  parent_id = var.resource_group_id

  body = jsonencode({
    properties = {
      tenantId = "${local.tenant_id}"
    }
  })
}

# data "azapi_resource" "powerbi_reponse" {
#   type      = "Microsoft.PowerBI/privateLinkServicesForPowerBI@2020-06-01"
#   name      = azurerm_web_pubsub.powerbi.name
#   parent_id = azurerm_resource_group.azapi_labs.id

#   depends_on = [
#     azapi_update_resource.webpubsub_identity
#   ]
# }
