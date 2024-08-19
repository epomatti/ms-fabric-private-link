resource "azurerm_container_registry" "acr" {
  name                = "cr${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = var.allowed_cidr
    }
  }

  network_rule_bypass_option = "AzureServices"
}
