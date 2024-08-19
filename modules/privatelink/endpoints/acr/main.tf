resource "azurerm_private_dns_zone" "registry" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "registry" {
  name                  = "registry-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.registry.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Account Endpoint
resource "azurerm_private_endpoint" "registry" {
  name                = "pe-cr"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.registry.name

    private_dns_zone_ids = [
      azurerm_private_dns_zone.registry.id
    ]
  }

  private_service_connection {
    name                           = "registry"
    private_connection_resource_id = var.acr_id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}
