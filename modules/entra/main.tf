data "azuread_client_config" "current" {}

resource "azuread_application" "fabricapp" {
  display_name = "${var.workload}-fabricapp"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "fabricapp" {
  client_id = azuread_application.fabricapp.client_id
  owners    = [data.azuread_client_config.current.object_id]
}
