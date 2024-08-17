locals {
  cidr = "10.0"
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["${local.cidr}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${local.cidr}.0.0/24"]
}

resource "azurerm_subnet" "compute" {
  name                 = "compute"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${local.cidr}.10.0/24"]
}
