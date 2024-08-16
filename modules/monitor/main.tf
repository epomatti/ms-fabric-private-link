resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
