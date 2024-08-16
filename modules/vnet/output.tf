output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}
