resource "azurerm_container_registry" "acr" {
  name                = "cr${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  network_rule_set {
    default_action = "Deny"

    ip_rule = [
      for ip in var.allowed_source_address_prefixes : {
        action   = "Allow"
        ip_range = ip
      }
    ]
  }

  network_rule_bypass_option = "AzureServices"
}
