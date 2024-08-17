terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.15.0"
    }
  }
}

locals {
  workload = "litware"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "pls_fabric" {
  source            = "./modules/privatelink/services/fabric"
  location          = azurerm_resource_group.default.location
  resource_group_id = azurerm_resource_group.default.id
}

module "ple_fabric" {
  source              = "./modules/privatelink/endpoints/fabric"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  vnet_id             = module.vnet.vnet_id
  subnet_id           = module.vnet.private_endpoints_subnet_id
  fabric_pls_id       = module.pls_fabric.id
}

module "vm" {
  source              = "./modules/vm"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  subnet_id       = module.vnet.compute_subnet_id
  size            = var.vm_size
  username        = var.vm_username
  public_key_path = var.vm_public_key_path

  image_publisher = var.vm_image_publisher
  image_offer     = var.vm_image_offer
  image_sku       = var.vm_image_sku
  image_version   = var.vm_image_version
}
