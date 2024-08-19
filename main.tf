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

resource "azurerm_resource_group" "default" {
  name     = "rg-${var.workload}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "nsg" {
  source                          = "./modules/nsg"
  workload                        = var.workload
  resource_group_name             = azurerm_resource_group.default.name
  location                        = azurerm_resource_group.default.location
  compute_subnet_id               = module.vnet.compute_subnet_id
  allowed_source_address_prefixes = var.allowed_source_address_prefixes
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

module "acr" {
  source              = "./modules/acr"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  allowed_cidr        = var.allowed_source_address_prefixes[0]
}

module "ple_acr" {
  source              = "./modules/privatelink/endpoints/acr"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  vnet_id             = module.vnet.vnet_id
  subnet_id           = module.vnet.private_endpoints_subnet_id
  acr_id              = module.acr.id
}

module "vm" {
  source              = "./modules/vm"
  workload            = var.workload
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

module "fabric_capacity" {
  source                   = "./modules/fabric"
  count                    = var.create_fabric_capacity ? 1 : 0
  workload                 = var.workload
  fabric_capacity_location = var.fabric_capacity_location
  sku_name                 = var.fabric_capacity_sku_name
}
