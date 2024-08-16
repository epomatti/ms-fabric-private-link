resource "azurerm_private_dns_zone" "analysis" {
  name                = "privatelink.analysis.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "pbidedicated" {
  name                = "privatelink.pbidedicated.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "powerquery" {
  name                = "privatelink.tip1.powerquery.microsoft.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "analysis" {
  name                  = "powerbi-analysis"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.analysis.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "pbidedicated" {
  name                  = "powerbi-pbidedicated"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pbidedicated.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "powerquery" {
  name                  = "powerbi-powerquery"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.powerquery.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Account Endpoint
resource "azurerm_private_endpoint" "fabric" {
  name                = "fabric-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name = "fabric"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.analysis.id,
      azurerm_private_dns_zone.pbidedicated.id,
      azurerm_private_dns_zone.powerquery.id
    ]
  }

  private_service_connection {
    name                           = "fabric"
    private_connection_resource_id = var.fabric_pls_id
    is_manual_connection           = false
    subresource_names              = ["tenant"]
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.analysis,
    azurerm_private_dns_zone_virtual_network_link.pbidedicated,
    azurerm_private_dns_zone_virtual_network_link.powerquery
  ]
}
